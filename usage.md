# Argosbx 修理版使用说明

本文档对应目录下的 `argosbx.sh`（已包含 `exvl / exvm / exhy2` 落地机参数）。

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

## 4. 重要文件位置

- Xray 配置：`~/agsbx/xr.json`
- Sing-box 配置：`~/agsbx/sb.json`
- 聚合节点：`~/agsbx/jh.txt`
- Argo 端口记录：`~/agsbx/argoport.log`
- 落地机持久参数：`~/agsbx/exit_vless` / `~/agsbx/exit_vmess` / `~/agsbx/exit_hy2`

## 5. 常见问题

### 5.1 报错：`syntax error near unexpected token $'{\r''`

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

### 5.2 `res` 后感觉“程序没了”

`res` 是重启，不会删除配置。常见原因是配置错误导致重启后起不来。

建议先测试配置：

```bash
~/agsbx/xray run -test -c ~/agsbx/xr.json
```

通过后再执行：

```bash
agsbx res
```

### 5.3 `rep` 与 `res` 区别

- `rep`：会清理并重建配置文件（`xr.json/sb.json` 等）
- `res`：仅重启进程，不重建配置

如果你手改过配置，只想重启，请用 `res`，不要用 `rep`。
