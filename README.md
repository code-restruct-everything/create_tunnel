# deeplx-argo.sh Usage

`deeplx-argo.sh` is a helper script to connect a local port (default `127.0.0.1:7860`) to Cloudflare Tunnel.

## Commands

```bash
bash deeplx-argo.sh start
bash deeplx-argo.sh stop
bash deeplx-argo.sh restart
bash deeplx-argo.sh status
bash deeplx-argo.sh logs
```

## Modes

1. Fixed tunnel (token mode): provide both `ARGO_AUTH`/`agk` and `ARGO_DOMAIN`/`agn`.
2. Quick tunnel mode: if token/domain are not provided, script uses `--url` and returns a `trycloudflare.com` domain.

## Environment Variables

- `LOCAL_HOST` default: `127.0.0.1`
- `LOCAL_PORT` default: `7860`
- `ARGO_DOMAIN` or `agn`: your domain (for fixed tunnel mode)
- `ARGO_AUTH` or `agk`: Cloudflare tunnel token (for fixed tunnel mode)

## Examples

Quick tunnel:

```bash
LOCAL_PORT=7860 bash deeplx-argo.sh start
```

Fixed tunnel (argosbx-style variables):

```bash
agn='api.example.com' agk='YOUR_TUNNEL_TOKEN' LOCAL_PORT=7860 bash deeplx-argo.sh start
```

## Notes

- Script auto-downloads `cloudflared` if missing.
- `status` prints fixed domain in token mode.
- In quick mode, `status` tries to extract the generated `trycloudflare.com` domain from logs.
