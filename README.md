# deeplx-argo.sh 使用说明

`deeplx-argo.sh` 用于把本地服务通过 Cloudflare Tunnel 暴露到公网。

## 命令

```bash
bash deeplx-argo.sh start
bash deeplx-argo.sh stop
bash deeplx-argo.sh restart
bash deeplx-argo.sh status
bash deeplx-argo.sh logs
```

## 运行模式

1. 固定隧道（Token 模式）
   只需要 `ARGO_AUTH`/`agk`。
   `ARGO_DOMAIN`/`agn` 可选，仅用于 `status` 显示。
2. 临时隧道（Quick Tunnel）
   没有 token 时，脚本使用 `--url`，返回 `trycloudflare.com` 域名。

## 环境变量

- `TUNNEL_NAME` 或 `INSTANCE`：实例名，用于多实例并行
- `LOCAL_HOST`：默认 `127.0.0.1`
- `LOCAL_PORT`：默认 `7860`
- `ARGO_AUTH` 或 `agk`：Cloudflare Tunnel Token（固定隧道必填）
- `ARGO_DOMAIN` 或 `agn`：可选域名，仅用于状态展示

## 关键结论

- 固定隧道模式下，`agk/ARGO_AUTH` 必填。
- 固定隧道模式下，`LOCAL_PORT` 不是必填。
  映射目标由 Cloudflare Dashboard 中该 Tunnel 的 Public Hostname -> Service 配置决定。
- 临时隧道模式下，`LOCAL_PORT` 很重要，因为会直接用到 `--url http://LOCAL_HOST:LOCAL_PORT`。

## 示例

临时隧道：

```bash
LOCAL_PORT=7860 bash deeplx-argo.sh start
```

固定隧道（仅 token，最小命令）：

```bash
agk='YOUR_TUNNEL_TOKEN' bash deeplx-argo.sh start
```

固定隧道（带域名，仅用于状态展示）：

```bash
agn='api.example.com' agk='YOUR_TUNNEL_TOKEN' bash deeplx-argo.sh start
```

多实例并行：

```bash
TUNNEL_NAME=translate agk='TOKEN_A' bash deeplx-argo.sh start
TUNNEL_NAME=jupyter   agk='TOKEN_B' LOCAL_PORT=1188 bash deeplx-argo.sh start
```

## 补充说明（同一个 token）

- 同一个 `agk/ARGO_AUTH` 连接的是同一个 Cloudflare Tunnel。
- 该 Tunnel 下在 Cloudflare Dashboard 配置的其他映射规则，也可以由当前连接器承接。
- 不需要为同一个 Tunnel 的每个域名单独申请新 token。
- 前提是映射对应的源站对当前连接器可访问。

## 备注

- 缺少 `cloudflared` 时脚本会自动下载。
- `status` 在固定模式显示传入域名（若提供），临时模式会尝试从日志提取 `trycloudflare.com` 域名。
