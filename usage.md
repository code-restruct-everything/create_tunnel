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
补充：手改 `~/agsbx/xr.json`（例如 `domainStrategy`）后，执行 `agsbx res` 会按新配置加载；后续再执行 `agsbx rep` 会重新生成并覆盖手改内容。

## 7. 路由排查复盘清单（推荐收藏）

本节用于快速复盘「某端口到底走了 WARP、落地机，还是中转机直连」。

### 7.1 一键采集关键信息

```bash
{
  echo '===== ip rule ====='
  ip rule
  echo
  echo '===== ip -4 route ====='
  ip -4 route
  echo
  echo '===== ip -6 route ====='
  ip -6 route
  echo
  echo '===== wg show ====='
  wg show
  echo
  echo '===== xr.json key lines ====='
  grep -n '"outboundTag"\|"outbound"\|"tag": "warp-out"\|"tag": "x-warp-out"\|"to-exit-node"\|"domainStrategy"' ~/agsbx/xr.json 2>/dev/null
  echo
  echo '===== vmws nodes ====='
  cat ~/agsbx/vmws_nodes 2>/dev/null
  echo
  echo '===== vmws node files ====='
  ls -l ~/agsbx/vmws_nodes.d/ 2>/dev/null
  echo
  echo '===== argo vmws map ====='
  cat ~/agsbx/argo_vmws_map.log 2>/dev/null
} > log.txt
```

### 7.2 结果如何解读（最实用）

1. `ip rule`  
只看到 `local/main/default`：说明没有额外策略路由劫持（系统层较干净）。

2. `ip -4 route` / `ip -6 route`  
- `default via ... dev eth0`：本机 IPv4 默认走网卡直连。  
- 有 `wg0` 地址：机器存在 WARP/WireGuard 隧道能力。

3. `~/agsbx/xr.json`  
- 出现 `to-exit-node-xxxxx`：该端口有落地机出站。  
- 出现 `outboundTag: "warp-out"`：该规则命中后走 WARP。  
- 规则顺序即优先级：前面命中就不会再走后面的规则。  
- 尾部通常是全局默认规则（未命中前置规则时的去向）。

4. `~/agsbx/vmws_nodes.d/*.conf`  
可反查每个端口是否有 `exvl/exvm/exhy2`（落地机）和 `xwd/xws`（前置 WARP 例外）。

5. `~/agsbx/argo_vmws_map.log`  
可确认「端口 -> Argo 域名」的一一映射关系，排除“连错端口/域名”。

### 7.3 端口级路由定位模板

定位某个端口（例如 `45681`）时，按下面顺序判断：

1. 先查是否有该端口专属 `xwd_45681/xws_45681`（命中则先走 `warp-out`）。  
2. 再查是否有该端口专属落地机 `exvl_45681/exvm_45681/exhy2_45681`。  
3. 若无专属落地，再看全局落地机 `exvl/exvm/exhy2`。  
4. 最后看尾部默认规则（通常是 `warp-out` 或 `direct`）。

### 7.4 验证「本机出口」与「节点出口」

本机出口（不代表节点出口）：

```bash
curl -4 --max-time 8 https://api-ipv4.ip.sb/ip
curl -6 --max-time 8 https://api-ipv6.ip.sb/ip
```

节点出口（推荐在客户端连接对应节点后访问）：
- `https://ip.sb`
- `https://ping0.cc`

说明：本机 `curl` 测的是系统路由；客户端连节点后访问网站，测的是节点链路路由。

### 7.5 `wg0` 与 Xray WARP 的关系

脚本里不会直接执行 `ip link add wg0` 或 `wg-quick up wg0`，但 Xray 的 `wireguard` outbound 会在 Linux 上创建系统可见的 `wg0`，并可能写入策略路由。

关键配置在 `~/agsbx/xr.json`：

```json
{
  "tag": "x-warp-out",
  "protocol": "wireguard",
  "settings": {
    "address": [
      "172.16.0.2/32",
      "2606:4700:110:.../128"
    ]
  }
}
```

常见现场现象：

```bash
ifconfig wg0
ip -6 rule show
ip -6 route show table all
```

如果看到类似：

```text
from 2606:4700:110:... lookup 10230
default dev wg0 table 10230
```

含义是：源地址为 WARP IPv6 的流量会查 `10230` 表，然后从 `wg0` 出口走 WARP。

### 7.6 为什么普通 SOCKS 的 IPv6 也可能走 WARP

如果本机有一个普通直连 SOCKS，例如：

```bash
gost -L socks5://user:pass@0.0.0.0:2080
```

它本身并不懂 WARP；但如果 Xray 已经创建了 `wg0` 与 IPv6 策略路由，本机进程访问 IPv6 目标时可能会选中 `wg0` 的 WARP IPv6 源地址，从而命中：

```text
from 2606:4700:110:... lookup 10230
default dev wg0 table 10230
```

这时 `2080` 会表现成：

```text
IPv4 -> eth0 -> VPS 原生 IPv4
IPv6 -> wg0 -> WARP/Cloudflare IPv6
```

验证方式：

```bash
curl -x socks5h://user:pass@127.0.0.1:2080 https://api.ipify.org
curl -x socks5h://user:pass@127.0.0.1:2080 https://api6.ipify.org
ip -4 rule show
ip -4 route show table all | grep 10230
ip -6 rule show
ip -6 route show table all
```

如果 IPv4 没有 `table 10230`，但 IPv6 有 `table 10230`，就会出现“IPv4 是 VPS，IPv6 是 WARP”的双出口结果。

### 7.7 `1080` 上游 SOCKS 与 `2080` 直连 SOCKS 的区别

直连 SOCKS：

```bash
gost -L socks5://user:pass@0.0.0.0:2080
```

由本机系统路由决定出口，所以会受 `wg0/table 10230` 影响。

带上游 SOCKS：

```bash
gost -L socks5://user:pass@0.0.0.0:1080 -F socks5://上游IP:1080
```

本机只负责连接上游 SOCKS。最终访问目标网站的是上游 SOCKS 所在机器，因此：

- 本机到上游 IP 是 IPv4 时，通常走本机 `eth0`。
- 目标网站的 IPv4/IPv6 出口由上游 SOCKS 决定。
- 本机的 `wg0/table 10230` 通常不会决定目标网站的最终出口。

验证方式：

```bash
curl -x socks5h://user:pass@127.0.0.1:1080 https://api.ipify.org
curl -x socks5h://user:pass@127.0.0.1:1080 https://api6.ipify.org
```

### 7.8 Worker 使用 SOCKS 时的路由判断

如果 Cloudflare Worker 节点配置了 SOCKS 反代，例如 `socks5=user:pass@VPS:2080`，链路通常是：

```text
客户端 -> Cloudflare Worker -> VPS:2080 -> gost -> 目标网站
```

如果 `2080` 是直连 SOCKS，那么最终出口仍由 VPS 系统路由决定。结合上面的 `wg0/table 10230`，可能显示：

```text
IPv4 = VPS 原生 IPv4
IPv6 = WARP/Cloudflare IPv6
```

若 Worker 是“非全局 SOCKS”模式，还要看 Worker 的直连白名单/优先规则。命中直连规则时，Worker 可能先自己直连目标；未命中时走 SOCKS。

### 7.9 清理旧 WARP 路由残留

修理版脚本已加入 `cleanup_warp_kernel_state`，会在重建/重启 Xray 前清理常见残留：

```text
ip -6 rule ... lookup 10230
ip -6 route table 10230
ip route table 10230
匹配 172.16.0.2/32 或 2606:4700:110: 的 wg0
```

它的目的不是禁止 Xray 创建 `wg0`，而是避免重复重启后旧规则堆积。新 Xray 启动后，如果仍启用 `x-warp-out`，会重新创建干净的 `wg0/table 10230`。

如果想禁止 Xray 创建系统可见的 `wg0`，需要在 `x-warp-out` 的 WireGuard settings 中使用用户态模式，例如研究添加：

```json
"noKernelTun": true
```

注意：这会改变 WARP outbound 的运行方式，建议先单独测试。

### 7.10 `warp=sx` 与 `domainStrategy`

当前修理版中，双栈可用时：

```text
warp=sx / warp=xs / warp 为空
```

会让 Xray 的 `direct` 与 `warp-out` 出站生成：

```json
"domainStrategy": "ForceIPv6v4"
```

`domainStrategy` 只影响 Xray 自己对域名的解析/连接倾向；它不是 `gost 2080` 走 WARP 的根因。`gost 2080` 的 IPv6 走 WARP，根因是系统里存在 `wg0 + ip -6 rule + table 10230`。

常见疑问：为什么我明明设置了 `warp=sx`，结果还是 `ForceIPv4`？

- 脚本会在生成配置时先探测 IPv4/IPv6 连通性（`curl -4/-6` 或 `wget -4/-6`）。
- 若当时只探测到 IPv4 可用，脚本会回退把 Xray `domainStrategy` 写成 `ForceIPv4`。
- 因此，同一台机在不同时间 `rep`，可能出现不同策略结果。

现场修复（只改当前生效配置）：

```bash
sed -i 's/"domainStrategy":"ForceIPv4"/"domainStrategy":"ForceIPv6v4"/g' ~/agsbx/xr.json
agsbx res
grep -n '"domainStrategy"' ~/agsbx/xr.json
```

持久修复（避免后续 `rep` 又改回）：

- 修改 `argosbx.sh` 中 `elif [ "$v4_ok" = true ]; then` 分支，把
`xryx='ForceIPv4'` / `wxryx='ForceIPv4'` 改为 `ForceIPv6v4`。
- 修改后重新执行一次 `bash argosbx.sh rep`。

### 7.11 现场复查命令合集

确认 `wg0` 与 WARP 地址：

```bash
ifconfig wg0
ip addr show dev wg0
```

确认 IPv4 是否被 WARP 接管：

```bash
ip -4 rule show
ip -4 route show table all | grep 10230
ip -4 route get 1.1.1.1
ip -4 route get 1.1.1.1 from 172.16.0.2
```

确认 IPv6 是否通过 `table 10230` 走 `wg0`：

```bash
ip -6 rule show
ip -6 route show table all
ip -6 route show table 10230
dig +short AAAA api6.ipify.org
ip -6 route get $(dig +short AAAA api6.ipify.org | head -n1)
ip -6 route get $(dig +short AAAA api6.ipify.org | head -n1) from $(ip -6 addr show dev wg0 scope global | awk '/inet6/ { sub("/.*", "", $2); print $2; exit }')
```

检查是否有 nft/iptables 接管：

```bash
nft list ruleset | grep -Ei 'wg0|mark|fwmark|2080|gost|meta|skuid'
ip6tables -t mangle -S
ip6tables -t nat -S
iptables -t mangle -S
iptables -t nat -S
```

确认 `gost` 监听与进程参数：

```bash
ps -ef | grep '[g]ost'
ss -lntp | grep ':2080'
ss -lntp | grep ':1080'
ss -6ntp | grep gost
```

直接测试 `2080` 直连 SOCKS 出口：

```bash
curl -x socks5h://user:pass@127.0.0.1:2080 https://api.ipify.org
curl -x socks5h://user:pass@127.0.0.1:2080 https://api6.ipify.org
```

直接测试 `1080` 上游 SOCKS 出口：

```bash
curl -x socks5h://user:pass@127.0.0.1:1080 https://api.ipify.org
curl -x socks5h://user:pass@127.0.0.1:1080 https://api6.ipify.org
```

查看 Xray 关键路由与 WARP 出站：

```bash
grep -n '"outboundTag"\|"outbound"\|"tag": "warp-out"\|"tag": "x-warp-out"\|"to-exit-node"\|"domainStrategy"' ~/agsbx/xr.json
grep -n '"protocol": "wireguard"\|"address": \[\|"allowedIPs"\|"endpoint"\|"reserved"' ~/agsbx/xr.json
```

重启/重建后确认旧规则是否被清掉：

```bash
agsbx res
ip -6 rule show
ip -6 route show table 10230
```

预期是旧的重复 `lookup 10230` 规则减少；如果仍启用 `x-warp-out`，新的 `wg0/table 10230` 还会重新出现。

### 7.12 日志脱敏后再分享

生成脱敏副本（保留原文件）：

```bash
perl -0777 -pe 's/\b(?:\d{1,3}\.){3}\d{1,3}\b//g; s/\b(?:[0-9A-Fa-f]{1,4}:){2,}[0-9A-Fa-f:]*\b//g; s/("id"\s*:\s*)"[^"]*"/$1""/g; s/("secretKey"\s*:\s*)"[^"]*"/$1""/g; s/("publicKey"\s*:\s*)"[^"]*"/$1""/g; s/("endpoint"\s*:\s*)"[^"]*"/$1""/g; s/("address"\s*:\s*)"[^"]*"/$1""/g; s/("Host"\s*:\s*)"[^"]*"/$1""/g; s/("path"\s*:\s*)"[^"]*"/$1""/g; s/(\b(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b)//g; s/\b(exvl_b64|exvm_b64|exhy2_b64|xwd_b64|xws_b64)=[^\r\n]*/$1=/g;' log.txt > log.sanitized.txt
```

### 7.13 多端口案例复盘（45678-45682）

以下复盘结论基于这类多端口规则顺序：先匹配端口前置规则，再匹配端口主规则，最后命中全局兜底规则。

- `45678 / 45679 / 45680`：
先匹配该端口 `xwd/xws`（命中走 `warp-out`），其余流量走对应 `to-exit-node-<port>` 落地机出站。
- `45681`：
没有专属 `to-exit-node-45681`，也没有端口前置规则时，最终走全局兜底，表现为全流量 `warp-out`。
- `45682`：
如果只有 `xws` 前置规则、没有专属落地机出站，命中 `xws` 走 `warp-out`，其余也会落到全局兜底 `warp-out`，实质也是全流量 WARP。

排查时两个高频信号：

- `routing.rules` 出现 `"domain": ["domain:"]`：
通常是 `xwd` 被留空或脱敏过度导致的无效匹配项，建议删掉或填真实域名后缀。
- `~/agsbx/argo_vmws_map.log` 出现 `45681|` 这种空域名映射：
表示该端口缺少可用 Argo 域名入口，外部通常无法按域名访问该端口。

### 7.14 文档脱敏边界（避免误公开）

- `usage.md` 建议只保留占位符示例（`你的UUID/你的token` 等）。
- `usage.sh` 常包含真实参数（token、UUID、IP、域名、密码、节点 URI），公开前必须单独清理。
- 需要对外共享排障信息时，优先共享 `usage.md` 和经过第 7.12 脱敏后的日志。
