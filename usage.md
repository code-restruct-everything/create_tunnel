# Argosbx 修理版使用说明

本文档对应目录下的 `argosbx.sh`（已包含 `exvl / exvm / exhy2` 落地机参数，以及 WARP 接入与域名/规则集分流参数）。

## 1. 快速开始

在 Linux 服务器上进入脚本目录后运行：

```bash
bash argosbx.sh
```

如果你要指定协议和参数，可按变量方式运行，例如：

```bash
uuid="你的UUID" vmpt="46464" argo="vmpt" agn="你的域名" agk="你的token" bash argosbx.sh
```

## 2. 常用命令

- 查看节点：`agsbx list` 或 `bash argosbx.sh list`
- 重启进程：`agsbx res` 或 `bash argosbx.sh res`
- 重置并重建配置：`agsbx rep` 或 `bash argosbx.sh rep`
- 更新 xray：`agsbx upx`
- 更新 sing-box：`agsbx ups`
- 卸载：`agsbx del`

## 3. 落地机参数（exvl / exvm / exhy2）

脚本现在支持 3 种落地链接（任选其一）：

- `exvl`：`vless://`（当前自动化仅支持 `security=reality`）
- `exvm`：`vmess://`（支持常见 VMess URI，优先按 ws/tls 生成）
- `exhy2`：`hysteria2://`

### 3.1 VLESS-Reality 落地（exvl）

```bash
uuid="你的UUID" vmpt="46464" argo="vmpt" \
exvl="vless://UUID@IP:PORT?encryption=none&flow=xtls-rprx-vision&security=reality&sni=apple.com&fp=chrome&pbk=公钥&sid=短ID" \
bash argosbx.sh
```

### 3.2 VMess 落地（exvm）

```bash
uuid="你的UUID" vmpt="46464" argo="vmpt" \
exvm="vmess://你的Base64节点字符串" \
bash argosbx.sh
```

### 3.3 Hysteria2 落地（exhy2）

```bash
uuid="你的UUID" vmpt="46464" argo="vmpt" \
exhy2="hysteria2://密码@IP:端口?security=tls&alpn=h3&insecure=1&sni=www.bing.com" \
bash argosbx.sh
```

说明：

- 不设置任何 `exvl/exvm/exhy2`：脚本按原逻辑运行（direct/warp），可正常使用。
- 只建议同时设置一个落地参数；脚本会优先使用你当前传入的参数并覆盖旧的落地缓存。
- 落地配置会持久化到 `~/agsbx/exit_vless`、`~/agsbx/exit_vmess`、`~/agsbx/exit_hy2` 之一。

关闭落地机转发（任选）：

```bash
exvl="off" exvm="off" exhy2="off" bash argosbx.sh rep
```

或手动删除：

```bash
rm -f ~/agsbx/exit_vless ~/agsbx/exit_vmess ~/agsbx/exit_hy2
```

## 4. WARP 接入与分流参数

### 4.1 WARP 出站模式（`warp`）

常见值：

- `warp=sx`：sing-box 与 xray 都优先走 WARP（常用）
- `warp=s`：仅 sing-box 走 WARP，xray 走直连
- `warp=x`：仅 xray 走 WARP，sing-box 走直连
- `warp=s4 / s6 / x4 / x6`：按 IPv4/IPv6 倾向细分

示例：

```bash
warp="sx" vmpt="46464" argo="vmpt" bash argosbx.sh rep
```

说明：

- 脚本会优先尝试通过 Cloudflare API 动态生成 WARP 账户参数。
- 若动态获取失败，会回退到原有方式与兜底参数。

### 4.2 手动指定 WARP 参数（可选）

如果你要固定 WARP 账户，可传入：

- `warppvk`：WireGuard 私钥
- `warpipv6`：WARP 分配的 IPv6 地址（不带 `/128`）
- `warpres`：`reserved`，格式如 `[1, 2, 3]`

示例：

```bash
warp="sx" \
warppvk="你的private_key" \
warpipv6="2606:4700:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx" \
warpres="[1, 2, 3]" \
bash argosbx.sh rep
```

### 4.3 域名/规则集分流参数

新增 4 个参数（支持短名和全名）：

- `wfd` / `warp_domain_suffix`：这些域名后缀走 `warp-out`
- `dfd` / `direct_domain_suffix`：这些域名后缀走 `direct`
- `wfs` / `warp_rule_set`：这些 geosite 规则集走 `warp-out`
- `dfs` / `direct_rule_set`：这些 geosite 规则集走 `direct`

填写规则：

- 可用空格、逗号、分号分隔多个值。
- `wfd/dfd` 直接填域名后缀，例如 `openai.com netflix.com`。
- `wfs/dfs` 填 geosite 名称，例如 `openai netflix geolocation-cn`。

示例 1（仅域名后缀分流）：

```bash
warp="sx" \
wfd="openai.com netflix.com" \
dfd="qq.com taobao.com" \
bash argosbx.sh rep
```

示例 2（域名后缀 + geosite 规则集分流）：

```bash
warp="sx" \
wfd="openai.com" \
dfd="qq.com" \
wfs="openai netflix" \
dfs="geolocation-cn" \
bash argosbx.sh rep
```

分流优先级：

- 已启用落地机时，如果设置了 `xwd/xws`，这些“前置例外”会先走 `warp-out`。
- 未命中前置例外的流量，再走落地机（`exvl/exvm/exhy2`）。
- 不走落地机或未命中落地机时，再匹配你设置的 `wfd/dfd/wfs/dfs`。
- 最后才走脚本原有的 `ip_cidr/final` 默认出口。

### 4.4 落地机前置例外分流（`xwd / xws`）

用于“其他都走落地机，但指定站点先走 WARP”。

- `xwd` / `exit_warp_domain_suffix`：前置例外的域名后缀（走 `warp-out`）
- `xws` / `exit_warp_rule_set`：前置例外的 geosite 规则集（走 `warp-out`）

示例：YouTube 走 WARP，其他走落地机

```bash
warp="sx" \
exvl="vless://UUID@IP:PORT?encryption=none&flow=xtls-rprx-vision&security=reality&sni=apple.com&fp=chrome&pbk=公钥&sid=短ID" \
xwd="youtube.com youtu.be googlevideo.com ytimg.com youtubei.googleapis.com" \
bash argosbx.sh rep
```

也可以用 geosite：

```bash
warp="sx" \
exvl="vless://UUID@IP:PORT?encryption=none&flow=xtls-rprx-vision&security=reality&sni=apple.com&fp=chrome&pbk=公钥&sid=短ID" \
xws="youtube" \
bash argosbx.sh rep
```

### 4.5 单脚本多节点（多端口 + 独立规则）

脚本已支持 `vmess+ws` 多节点模式。每个端口都可以有独立的：

- 落地机：`exvl_<端口>` / `exvm_<端口>` / `exhy2_<端口>`
- 前置例外：`xwd_<端口>` / `xws_<端口>`

其中，单节点路由顺序是：

1. 先匹配该端口自己的 `xwd_<端口>` / `xws_<端口>`，命中走 `warp-out`
2. 未命中则走该端口自己的落地机（`exvl_<端口>` 等）
3. 若该端口未配置落地机，再回落到全局落地机（`exvl/exvm/exhy2`，如有）
4. 最后才到全局 `wfd/dfd/wfs/dfs` 与默认出口规则

方式 A（推荐）：`vmws` + 端口变量

```bash
warp="sx" \
vmws="46464 46465" \
exvl_46464="vless://UUID@IP1:PORT1?encryption=none&flow=xtls-rprx-vision&security=reality&sni=apple.com&fp=chrome&pbk=公钥1&sid=短ID1" \
xws_46464="youtube" \
exvl_46465="vless://UUID@IP2:PORT2?encryption=none&flow=xtls-rprx-vision&security=reality&sni=apple.com&fp=chrome&pbk=公钥2&sid=短ID2" \
bash argosbx.sh rep
```

方式 B：数组写法 `vmwa`（适合一条命令传完）

- 分号 `;` 分隔节点
- 每个节点用 `|` 分隔字段
- 建议在 `xwd` 内用逗号分隔多个域名（避免空格拆词）

```bash
warp="sx" \
vmwa="46464|xwd=youtube.com,googlevideo.com,ytimg.com|xws=youtube|exvl=vless://UUID@IP1:PORT1?encryption=none&flow=xtls-rprx-vision&security=reality&sni=apple.com&fp=chrome&pbk=公钥1&sid=短ID1;46465|exvl=vless://UUID@IP2:PORT2?encryption=none&flow=xtls-rprx-vision&security=reality&sni=apple.com&fp=chrome&pbk=公钥2&sid=短ID2" \
bash argosbx.sh rep
```

固定 token 多端口（同一个 Tunnel）：

- 你需要先在 Cloudflare Dashboard 里把各域名分别映射到对应端口服务（如 `http://localhost:46464`、`http://localhost:46465`）。
- 脚本侧用同一个 `agk`，并把 `agn` 按端口顺序填写多个域名（空格/逗号/分号都可）。

```bash
warp="sx" \
vmws="46464 46465" \
agn="a.example.com b.example.com" \
agk="你的TunnelToken" \
exvl_46464="vless://..." xws_46464="youtube" \
exvl_46465="vless://..." \
bash argosbx.sh rep
```

说明：

- 端口与域名按顺序对应：`46464 -> a.example.com`，`46465 -> b.example.com`。
- 如果 `agn` 只填一个域名，脚本会默认复用该域名到所有端口（前提是你在 Dashboard 也做了可用的路由规则）。

持久化说明：

- 首次 `rep` 后，脚本会把多节点配置写入 `~/agsbx/vmws_nodes` 和 `~/agsbx/vmws_nodes.d/`。
- 之后执行 `agsbx res` 或重启恢复，会继续沿用这些配置（无需每次重传全部变量）。

关闭多节点模式：

```bash
vmws="off" vmwa="off" bash argosbx.sh rep
```

## 5. 重要文件位置

- Xray 配置：`~/agsbx/xr.json`
- Sing-box 配置：`~/agsbx/sb.json`
- 聚合节点：`~/agsbx/jh.txt`
- Argo 端口记录：`~/agsbx/argoport.log`
- 多节点端口列表：`~/agsbx/vmws_nodes`
- 多节点每端口配置：`~/agsbx/vmws_nodes.d/<port>.conf`
- 多节点 Argo 映射（临时/固定 token 共用）：`~/agsbx/argo_vmws_map.log`
- 落地机持久参数：`~/agsbx/exit_vless` / `~/agsbx/exit_vmess` / `~/agsbx/exit_hy2`

## 6. 常见问题

### 6.1 报错：`syntax error near unexpected token $'{\r''`

原因：脚本文件是 Windows 的 CRLF 行尾，Linux `sh` 解析失败。

修复：

```bash
sed -i 's/\r$//' argosbx.sh
# 或
# dos2unix argosbx.sh
```

然后检查语法：

```bash
bash -n argosbx.sh
```

### 6.2 `res` 后感觉“程序没了”

`res` 是重启，不会删除配置。常见原因是配置错误导致重启后起不来。

建议先测试配置：

```bash
~/agsbx/xray run -test -c ~/agsbx/xr.json
```

通过后再执行：

```bash
agsbx res
```

### 6.3 `rep` 与 `res` 区别

- `rep`：会清理并重建配置文件（`xr.json/sb.json` 等）
- `res`：仅重启进程，不重建配置

如果你手改过配置，只想重启，请用 `res`，不要用 `rep`。
