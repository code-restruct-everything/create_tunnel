#!/bin/sh
set -eu

# Argos-style cloudflared launcher for DeepLX-Mini (port 7860 by default).
# Priority is:
# 1) fixed tunnel via token (ARGO_AUTH/agk + ARGO_DOMAIN/agn),
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

  if [ -n "$ARGO_DOMAIN" ] && [ -n "$ARGO_AUTH" ]; then
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
Usage:
  bash ${script_name} start
  bash ${script_name} stop
  bash ${script_name} restart
  bash ${script_name} status
  bash ${script_name} logs

Environment variables:
  TUNNEL_NAME (preferred) / INSTANCE
    - multi-instance id, only [A-Za-z0-9._-] kept, others mapped to "_"
    - default: default
    - TUNNEL_NAME has higher priority than INSTANCE
  LOCAL_HOST (default: 127.0.0.1)
  LOCAL_PORT (default: 7860)

Fixed tunnel mode (same style as argosbx):
  ARGO_DOMAIN / agn   e.g. api.example.com
  ARGO_AUTH   / agk   tunnel token

When ARGO_DOMAIN + ARGO_AUTH are both set, script uses:
  cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token ...
Otherwise it uses quick tunnel:
  cloudflared tunnel --url http://LOCAL_HOST:LOCAL_PORT --edge-ip-version auto --no-autoupdate --protocol http2

Examples:
  # quick tunnel to local 7860
  LOCAL_PORT=7860 bash ${script_name} start

  # quick tunnel on a named instance
  TUNNEL_NAME=deeplx LOCAL_PORT=7860 bash ${script_name} start

  # fixed tunnel (argosbx-compatible vars)
  agn='api.example.com' agk='YOUR_TUNNEL_TOKEN' LOCAL_PORT=7860 bash ${script_name} start

  # run multiple fixed tunnels in parallel (different instances)
  TUNNEL_NAME=translate agn='translate.example.com' agk='TOKEN_A' LOCAL_PORT=7860 bash ${script_name} start
  TUNNEL_NAME=jupyter   agn='jupyter.example.com'   agk='TOKEN_B' LOCAL_PORT=1188 bash ${script_name} start

  # instance-specific status/logs/stop
  TUNNEL_NAME=translate bash ${script_name} status
  TUNNEL_NAME=translate bash ${script_name} logs
  TUNNEL_NAME=translate bash ${script_name} stop
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
