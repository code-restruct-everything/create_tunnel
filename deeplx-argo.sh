#!/bin/sh
set -eu

# Argos-style cloudflared launcher for local services (port 7860 by default).
# Priority is:
# 1) fixed tunnel via token (ARGO_AUTH/agk),
# 2) quick tunnel via --url.

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
# Multi-instance support:
# - TUNNEL_NAME has higher priority than INSTANCE.
# - default keeps backward-compatible state dir: ${ROOT_DIR}/cloudflared
INSTANCE_RAW="${TUNNEL_NAME:-${INSTANCE:-default}}"
INSTANCE_ID="$(printf '%s' "$INSTANCE_RAW" | tr -c 'A-Za-z0-9._-' '_')"
[ -n "$INSTANCE_ID" ] || INSTANCE_ID="default"

BASE_STATE_DIR="${ROOT_DIR}/cloudflared"
if [ "$INSTANCE_ID" = "default" ]; then
  STATE_DIR="${BASE_STATE_DIR}"
else
  STATE_DIR="${BASE_STATE_DIR}-${INSTANCE_ID}"
fi

BIN_PATH="${BASE_STATE_DIR}/cloudflared"
PID_FILE="${STATE_DIR}/argo.pid"
LOG_FILE="${STATE_DIR}/argo.log"
MODE_FILE="${STATE_DIR}/argo.mode"

LOCAL_HOST="${LOCAL_HOST:-127.0.0.1}"
LOCAL_PORT="${LOCAL_PORT:-7860}"

# Keep compatibility with argosbx variable names.
ARGO_DOMAIN="${ARGO_DOMAIN:-${agn:-}}"
ARGO_AUTH="${ARGO_AUTH:-${agk:-}}"

info() {
  printf '[deeplx-argo:%s] %s\n' "$INSTANCE_ID" "$*"
}

warn() {
  printf '[deeplx-argo:%s] %s\n' "$INSTANCE_ID" "$*" >&2
}

detect_arch() {
  arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64) echo "amd64" ;;
    aarch64|arm64) echo "arm64" ;;
    *) warn "Unsupported architecture: $arch"; exit 1 ;;
  esac
}

download_cloudflared() {
  if [ -x "$BIN_PATH" ]; then
    return 0
  fi

  mkdir -p "$BASE_STATE_DIR"
  cpu="$(detect_arch)"
  url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${cpu}"

  info "Downloading cloudflared (${cpu})..."
  if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 2 -o "$BIN_PATH" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$BIN_PATH" --tries=2 "$url"
  else
    warn "Need curl or wget to download cloudflared."
    exit 1
  fi

  chmod +x "$BIN_PATH"
}

is_running() {
  if [ ! -f "$PID_FILE" ]; then
    return 1
  fi

  pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  [ -n "$pid" ] || return 1
  kill -0 "$pid" 2>/dev/null
}

extract_quick_domain() {
  if [ ! -f "$LOG_FILE" ]; then
    return 1
  fi

  domain="$(grep -a "trycloudflare.com" "$LOG_FILE" 2>/dev/null \
    | awk 'NR==2{print}' \
    | awk -F// '{print $2}' \
    | awk '{print $1}')"

  if [ -n "$domain" ]; then
    printf '%s\n' "$domain"
    return 0
  fi

  grep -a "trycloudflare.com" "$LOG_FILE" 2>/dev/null \
    | head -n 1 \
    | awk -F// '{print $2}' \
    | awk '{print $1}'
}

start_tunnel() {
  if is_running; then
    info "Tunnel already running (pid: $(cat "$PID_FILE"))."
    return 0
  fi

  download_cloudflared
  mkdir -p "$STATE_DIR"

  if [ -n "$ARGO_AUTH" ]; then
    info "Starting fixed tunnel (token mode)..."
    nohup "$BIN_PATH" tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "$ARGO_AUTH" >"$LOG_FILE" 2>&1 &
    printf 'fixed\n%s\n' "$ARGO_DOMAIN" > "$MODE_FILE"
  else
    info "Starting quick tunnel (--url mode) to http://${LOCAL_HOST}:${LOCAL_PORT} ..."
    nohup "$BIN_PATH" tunnel --url "http://${LOCAL_HOST}:${LOCAL_PORT}" --edge-ip-version auto --no-autoupdate --protocol http2 >"$LOG_FILE" 2>&1 &
    printf 'quick\n' > "$MODE_FILE"
  fi

  echo "$!" > "$PID_FILE"
  sleep 6
  status_tunnel
}

stop_tunnel() {
  if ! is_running; then
    warn "Tunnel is not running."
    rm -f "$PID_FILE"
    return 0
  fi

  pid="$(cat "$PID_FILE")"
  kill "$pid" 2>/dev/null || true
  sleep 1
  if kill -0 "$pid" 2>/dev/null; then
    kill -9 "$pid" 2>/dev/null || true
  fi

  rm -f "$PID_FILE"
  info "Tunnel stopped."
}

status_tunnel() {
  if is_running; then
    info "Tunnel status: running (pid: $(cat "$PID_FILE"))."
  else
    info "Tunnel status: stopped."
    return 1
  fi

  mode="$(head -n 1 "$MODE_FILE" 2>/dev/null || true)"
  if [ "$mode" = "fixed" ]; then
    domain="$(sed -n '2p' "$MODE_FILE" 2>/dev/null || true)"
    [ -n "$domain" ] && info "Domain: ${domain}"
  else
    quick_domain="$(extract_quick_domain || true)"
    if [ -n "$quick_domain" ]; then
      info "Quick domain: ${quick_domain}"
    else
      info "Quick domain not ready yet. Check logs: ${LOG_FILE}"
    fi
  fi
}

show_logs() {
  if [ ! -f "$LOG_FILE" ]; then
    warn "No log file: $LOG_FILE"
    exit 1
  fi
  tail -n 60 "$LOG_FILE"
}

usage() {
  script_name="$(basename "$0")"
  cat <<EOF
用法:
  bash ${script_name} start
  bash ${script_name} stop
  bash ${script_name} restart
  bash ${script_name} status
  bash ${script_name} logs

环境变量:
  TUNNEL_NAME (推荐) / INSTANCE
    - 多实例名称，只保留 [A-Za-z0-9._-]，其他字符会转成 "_"
    - 默认: default
    - TUNNEL_NAME 优先级高于 INSTANCE
  LOCAL_HOST (默认: 127.0.0.1)
  LOCAL_PORT (默认: 7860)

固定隧道模式（与 argosbx 变量风格兼容）:
  ARGO_AUTH   / agk   Tunnel Token（必填）
  ARGO_DOMAIN / agn   例如: api.example.com（可选，仅用于 status 显示）

当 ARGO_AUTH 存在时，脚本使用:
  cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token ...
当 ARGO_AUTH 缺失时，使用临时隧道:
  cloudflared tunnel --url http://LOCAL_HOST:LOCAL_PORT --edge-ip-version auto --no-autoupdate --protocol http2

示例:
  # 临时隧道到本地 7860
  LOCAL_PORT=7860 bash ${script_name} start

  # 使用命名实例运行临时隧道
  TUNNEL_NAME=deeplx LOCAL_PORT=7860 bash ${script_name} start

  # 固定隧道（仅 token，LOCAL_PORT 非必填）
  agk='YOUR_TUNNEL_TOKEN' bash ${script_name} start

  # 固定隧道（带域名，仅用于 status 展示）
  agn='api.example.com' agk='YOUR_TUNNEL_TOKEN' bash ${script_name} start

  # 多实例并行固定隧道（不同实例名）
  TUNNEL_NAME=translate agn='translate.example.com' agk='TOKEN_A' LOCAL_PORT=7860 bash ${script_name} start
  TUNNEL_NAME=jupyter   agn='jupyter.example.com'   agk='TOKEN_B' LOCAL_PORT=1188 bash ${script_name} start

  # 针对实例查看状态/日志/停止
  TUNNEL_NAME=translate bash ${script_name} status
  TUNNEL_NAME=translate bash ${script_name} logs
  TUNNEL_NAME=translate bash ${script_name} stop

补充（同一个 token）:
  - 同一个 agk/ARGO_AUTH 连接的是同一个 Cloudflare Tunnel。
  - 该 Tunnel 下在 Cloudflare 里配置的其他映射规则，也可以被当前连接器承接。
EOF
}

cmd="${1:-start}"
case "$cmd" in
  start) start_tunnel ;;
  stop) stop_tunnel ;;
  restart) stop_tunnel; start_tunnel ;;
  status) status_tunnel ;;
  logs) show_logs ;;
  *) usage; exit 1 ;;
esac