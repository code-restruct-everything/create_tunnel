#!/bin/sh
export LANG=en_US.UTF-8
[ -z "${vlpt+x}" ] || vlp=yes
[ -z "${vmpt+x}" ] || { vmp=yes; vmag=yes; }
[ -z "${vwpt+x}" ] || { vwp=yes; vmag=yes; }
[ -z "${hypt+x}" ] || hyp=yes
[ -z "${tupt+x}" ] || tup=yes
[ -z "${xhpt+x}" ] || xhp=yes
[ -z "${vxpt+x}" ] || vxp=yes
[ -z "${anpt+x}" ] || anp=yes
[ -z "${sspt+x}" ] || ssp=yes
[ -z "${arpt+x}" ] || arp=yes
[ -z "${sopt+x}" ] || sop=yes
[ -z "${warp+x}" ] || wap=yes
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' || pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then
if [ "$1" = "rep" ]; then
[ "$vwp" = yes ] || [ "$sop" = yes ] || [ "$vxp" = yes ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || { echo "提示：rep重置协议时，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
else
[ "$1" = "del" ] || [ "$vwp" = yes ] || [ "$sop" = yes ] || [ "$vxp" = yes ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || { echo "提示：未安装argosbx脚本，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
export uuid=${uuid:-''}
export port_vl_re=${vlpt:-''}
export port_vm_ws=${vmpt:-''}
export port_vw=${vwpt:-''}
export port_hy2=${hypt:-''}
export port_tu=${tupt:-''}
export port_xh=${xhpt:-''}
export port_vx=${vxpt:-''}
export port_an=${anpt:-''}
export port_ar=${arpt:-''}
export port_ss=${sspt:-''}
export port_so=${sopt:-''}
export ym_vl_re=${reym:-''}
export cdnym=${cdnym:-''}
export argo=${argo:-''}
export ARGO_DOMAIN=${agn:-''}
export ARGO_AUTH=${agk:-''}
export exit_vless=${exvl:-${exit_vless:-''}}
export exit_vmess=${exvm:-${exit_vmess:-''}}
export exit_hy2=${exhy2:-${exit_hy2:-''}}
export ippz=${ippz:-''}
export warp=${warp:-''}
export name=${name:-''}
export oap=${oap:-''}
export vmws_nodes=${vmws:-${vmws_nodes:-''}}
export vmws_array=${vmwa:-${vmws_array:-''}}
vmws_clear=no
case "${vmws:-}" in off|OFF|none|NONE) vmws_clear=yes ;; esac
case "${vmwa:-}" in off|OFF|none|NONE) vmws_clear=yes ;; esac
export warp_domain_suffix=${wfd:-${warp_domain_suffix:-''}}
export direct_domain_suffix=${dfd:-${direct_domain_suffix:-''}}
export warp_rule_set=${wfs:-${warp_rule_set:-''}}
export direct_rule_set=${dfs:-${direct_rule_set:-''}}
export exit_warp_domain_suffix=${xwd:-${exit_warp_domain_suffix:-''}}
export exit_warp_rule_set=${xws:-${exit_warp_rule_set:-''}}
v46url="https://icanhazip.com"
agsbxurl="https://raw.githubusercontent.com/yonggekkk/argosbx/main/argosbx.sh"
showmode(){
echo "Argosbx脚本一键SSH命令生器在线网址：https://yonggekkk.github.io/argosbx/"
echo "主脚本：bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosbx/main/argosbx.sh) 或 bash <(wget -qO- https://raw.githubusercontent.com/yonggekkk/argosbx/main/argosbx.sh)"
echo "显示节点信息命令：agsbx list 【或者】 主脚本 list"
echo "重置变量组命令：自定义各种协议变量组 agsbx rep 【或者】 自定义各种协议变量组 主脚本 rep"
echo "更新脚本命令：原已安装的自定义各种协议变量组 主脚本 rep"
echo "更新Xray或Singbox内核命令：agsbx upx或ups 【或者】 主脚本 upx或ups"
echo "重启脚本命令：agsbx res 【或者】 主脚本 res"
echo "卸载脚本命令：agsbx del 【或者】 主脚本 del"
echo "双栈VPS显示IPv4/IPv6节点配置命令：ippz=4或6 agsbx list 【或者】 ippz=4或6 主脚本 list"
echo "落地机参数（可选）：exvl=\"vless://...\" 或 exvm=\"vmess://...\" 或 exhy2=\"hysteria2://...\""
echo "---------------------------------------------------------"
echo
}
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "甬哥Github项目 ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "Argosbx一键无交互小钢炮脚本💣"
echo "当前版本：V25.11.20"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
hostname=$(uname -a | awk '{print $2}')
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[ -z "$(systemd-detect-virt 2>/dev/null)" ] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
arm64|aarch64) cpu=arm64;;
amd64|x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit
esac
mkdir -p "$HOME/agsbx"

normalize_disable_value(){
case "$1" in
off|OFF|none|NONE) echo "" ;;
*) echo "$1" ;;
esac
}

b64_encode_text(){
printf '%s' "$1" | base64 | tr -d '\n'
}

b64_decode_text(){
if [ -z "$1" ]; then
echo ""
elif decoded_text=$(printf '%s' "$1" | base64 -d 2>/dev/null); then
printf '%s' "$decoded_text"
else
printf '%s' "$1" | base64 --decode 2>/dev/null
fi
}

set_dynamic_var(){
dyn_name="$1"
dyn_value="$2"
dyn_escaped=$(printf "%s" "$dyn_value" | sed "s/'/'\"'\"'/g")
eval "$dyn_name='$dyn_escaped'"
}

parse_vmws_array(){
[ -n "$vmws_array" ] || return
parsed_vmws_nodes=""
while IFS= read -r node_item; do
[ -n "$node_item" ] || continue
node_item=$(echo "$node_item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
node_port=${node_item%%|*}
node_port=$(echo "$node_port" | tr -d '[:space:]')
case "$node_port" in ''|*[!0-9]*) continue ;; esac
case " $parsed_vmws_nodes " in *" $node_port "*) ;; *) parsed_vmws_nodes="$parsed_vmws_nodes $node_port" ;; esac
if [ "$node_item" = "$node_port" ]; then
node_tail=""
else
node_tail=${node_item#*|}
fi
while [ -n "$node_tail" ]; do
node_kv=${node_tail%%|*}
if [ "$node_tail" = "$node_kv" ]; then
node_tail=""
else
node_tail=${node_tail#*|}
fi
[ -n "$node_kv" ] || continue
node_key=${node_kv%%=*}
node_val=${node_kv#*=}
[ "$node_kv" = "$node_key" ] && node_val=""
case "$node_key" in
exvl|exvm|exhy2|xwd|xws) set_dynamic_var "${node_key}_${node_port}" "$node_val" ;;
esac
done
done <<EOF
$(printf '%s' "$vmws_array" | tr ';' '\n')
EOF
parsed_vmws_nodes=$(echo "$parsed_vmws_nodes" | xargs 2>/dev/null)
[ -n "$parsed_vmws_nodes" ] && vmws_nodes="$parsed_vmws_nodes"
}

load_vmws_saved_base(){
if [ "$vmws_clear" = yes ]; then
vmws_nodes=""
vmws_array=""
rm -f "$HOME/agsbx/vmws_nodes" "$HOME/agsbx/vmws_array" "$HOME/agsbx/vmws_ports_multi" "$HOME/agsbx/argo_vmws_map.log"
rm -rf "$HOME/agsbx/vmws_nodes.d"
return
fi
if [ -z "$vmws_nodes" ] && [ -s "$HOME/agsbx/vmws_nodes" ]; then
vmws_nodes=$(cat "$HOME/agsbx/vmws_nodes" 2>/dev/null)
fi
if [ -z "$vmws_array" ] && [ -z "$vmws_nodes" ] && [ -s "$HOME/agsbx/vmws_array" ]; then
vmws_array=$(cat "$HOME/agsbx/vmws_array" 2>/dev/null)
fi
[ -n "$vmws_array" ] && parse_vmws_array
}

read_vmws_node_cfg(){
node_cfg_port="$1"
node_cfg_exvl=""
node_cfg_exvm=""
node_cfg_exhy2=""
node_cfg_xwd=""
node_cfg_xws=""
node_cfg_file="$HOME/agsbx/vmws_nodes.d/${node_cfg_port}.conf"
[ -s "$node_cfg_file" ] || return
cfg_v=$(sed -n 's/^exvl_b64=//p' "$node_cfg_file" | head -n1)
node_cfg_exvl=$(b64_decode_text "$cfg_v")
cfg_v=$(sed -n 's/^exvm_b64=//p' "$node_cfg_file" | head -n1)
node_cfg_exvm=$(b64_decode_text "$cfg_v")
cfg_v=$(sed -n 's/^exhy2_b64=//p' "$node_cfg_file" | head -n1)
node_cfg_exhy2=$(b64_decode_text "$cfg_v")
cfg_v=$(sed -n 's/^xwd_b64=//p' "$node_cfg_file" | head -n1)
node_cfg_xwd=$(b64_decode_text "$cfg_v")
cfg_v=$(sed -n 's/^xws_b64=//p' "$node_cfg_file" | head -n1)
node_cfg_xws=$(b64_decode_text "$cfg_v")
}

write_vmws_node_cfg(){
node_cfg_port="$1"
mkdir -p "$HOME/agsbx/vmws_nodes.d"
node_cfg_file="$HOME/agsbx/vmws_nodes.d/${node_cfg_port}.conf"
if [ -z "$node_cfg_exvl" ] && [ -z "$node_cfg_exvm" ] && [ -z "$node_cfg_exhy2" ] && [ -z "$node_cfg_xwd" ] && [ -z "$node_cfg_xws" ]; then
rm -f "$node_cfg_file"
return
fi
cat > "$node_cfg_file" <<EOF
exvl_b64=$(b64_encode_text "$node_cfg_exvl")
exvm_b64=$(b64_encode_text "$node_cfg_exvm")
exhy2_b64=$(b64_encode_text "$node_cfg_exhy2")
xwd_b64=$(b64_encode_text "$node_cfg_xwd")
xws_b64=$(b64_encode_text "$node_cfg_xws")
EOF
}

load_vmws_saved_base

v4v6(){
v4=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- "$v46url" 2>/dev/null) )
v6=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- "$v46url" 2>/dev/null) )
v4dq=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k https://ip.fm | sed -E 's/.*Location: ([^,]+(, [^,]+)*),.*/\1/' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- https://ip.fm | grep '<span class="has-text-grey-light">Location:' | tail -n1 | sed -E 's/.*>Location: <\/span>([^<]+)<.*/\1/' 2>/dev/null) )
v6dq=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k https://ip.fm | sed -E 's/.*Location: ([^,]+(, [^,]+)*),.*/\1/' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- https://ip.fm | grep '<span class="has-text-grey-light">Location:' | tail -n1 | sed -E 's/.*>Location: <\/span>([^<]+)<.*/\1/' 2>/dev/null) )
}
load_warp_from_api(){
command -v curl >/dev/null 2>&1 || return 1
command -v openssl >/dev/null 2>&1 || return 1
command -v base64 >/dev/null 2>&1 || return 1
wg_private=''
wg_public=''
if command -v xxd >/dev/null 2>&1; then
key_pair=$(openssl genpkey -algorithm X25519 2>/dev/null | openssl pkey -text -noout 2>/dev/null)
wg_private=$(echo "$key_pair" | awk '/priv:/{flag=1; next} /pub:/{flag=0} flag' | tr -d '[:space:]' | xxd -r -p 2>/dev/null | base64 | tr -d '\n')
wg_public=$(echo "$key_pair" | awk '/pub:/{flag=1} flag' | tr -d '[:space:]' | xxd -r -p 2>/dev/null | base64 | tr -d '\n')
fi
if [ -z "$wg_private" ] || [ -z "$wg_public" ]; then
key_file="$HOME/agsbx/.warpkey.$$"
openssl genpkey -algorithm X25519 -out "$key_file" >/dev/null 2>&1 || { rm -f "$key_file"; return 1; }
wg_private=$(openssl pkey -in "$key_file" -outform DER 2>/dev/null | tail -c 32 | base64 | tr -d '\n')
wg_public=$(openssl pkey -in "$key_file" -pubout -outform DER 2>/dev/null | tail -c 32 | base64 | tr -d '\n')
rm -f "$key_file"
fi
[ -n "$wg_private" ] && [ -n "$wg_public" ] || return 1
api_resp=$(curl -sL --tlsv1.3 --connect-timeout 4 --max-time 8 \
-X POST "https://api.cloudflareclient.com/v0a2158/reg" \
-H "CF-Client-Version: a-7.21-0721" \
-H "Content-Type: application/json" \
-d "{\"key\":\"$wg_public\",\"tos\":\"$(date -u +'%Y-%m-%dT%H:%M:%S.000Z')\"}" 2>/dev/null)
[ -n "$api_resp" ] || return 1
api_compact=$(echo "$api_resp" | tr -d '\n\r ')
api_v6=$(echo "$api_compact" | sed -n 's/.*"v6":"\([^"]*\)".*/\1/p' | head -n1)
api_client_id=$(echo "$api_compact" | sed -n 's/.*"client_id":"\([^"]*\)".*/\1/p' | head -n1)
[ -n "$api_v6" ] && [ -n "$api_client_id" ] || return 1
api_reserved=$(printf '%s' "$api_client_id" | base64 -d 2>/dev/null | od -An -t u1 2>/dev/null | awk 'NF{print "["$1", "$2", "$3"]"; exit}')
[ -n "$api_reserved" ] || return 1
pvk="$wg_private"
wpv6="$api_v6"
res="$api_reserved"
return 0
}
warpsx(){
if [ -n "$warppvk" ] && [ -n "$warpipv6" ] && [ -n "$warpres" ]; then
pvk="$warppvk"
wpv6="$warpipv6"
res="$warpres"
elif ! load_warp_from_api; then
warpurl=$( (command -v curl >/dev/null 2>&1 && curl -sm5 -k https://ygkkk-warp.renky.eu.org 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget --tries=2 -qO- https://ygkkk-warp.renky.eu.org 2>/dev/null) )
if echo "$warpurl" | grep -q ygkkk; then
pvk=$(echo "$warpurl" | awk -F'：' '/Private_key/{print $2}' | xargs)
wpv6=$(echo "$warpurl" | awk -F'：' '/IPV6/{print $2}' | xargs)
res=$(echo "$warpurl" | awk -F'：' '/reserved/{print $2}' | xargs)
else
wpv6='2606:4700:110:8d8d:1845:c39f:2dd5:a03a'
pvk='52cuYFgCJXp0LAq7+nWJIbCXXgU9eGggOc+Hlfz5u6A='
res='[215, 69, 233]'
fi
fi
if [ -n "$name" ]; then
sxname=$name-
echo "$sxname" > "$HOME/agsbx/name"
echo
echo "所有节点名称前缀：$name"
fi
v4v6
if echo "$v6" | grep -q '^2a09' || echo "$v4" | grep -q '^104.28'; then
s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo
echo; echo "请注意：你已安装了warp"
else
if [ "$wap" != yes ]; then
s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo
else
case "$warp" in
""|sx|xs) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s ) s1outtag=warp-out; s2outtag=warp-out; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s4) s1outtag=warp-out; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s6) s1outtag=warp-out; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
x ) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
x4) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
x6) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s4x4|x4s4) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s4x6|x6s4) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s6x4|x4s6) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
s6x6|x6s6) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0"'; wap=warp ;;
sx4|x4s) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
sx6|x6s) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
xs4|s4x) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
xs6|s6x) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
* ) s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo ;;
esac
fi
fi
v4_ok=false
v6_ok=false
if command -v curl >/dev/null 2>&1; then
curl -s4m5 -k "$v46url" >/dev/null 2>&1 && v4_ok=true
elif command -v wget >/dev/null 2>&1; then
timeout 3 wget -4 --tries=2 -qO- "$v46url" >/dev/null 2>&1 && v4_ok=true
fi
if command -v curl >/dev/null 2>&1; then
curl -s6m5 -k "$v46url" >/dev/null 2>&1 && v6_ok=true
elif command -v wget >/dev/null 2>&1; then
timeout 3 wget -6 --tries=2 -qO- "$v46url" >/dev/null 2>&1 && v6_ok=true
fi
if [ "$v4_ok" = true ] && [ "$v6_ok" = true ]; then
case "$warp" in
*s6*) sbyx='prefer_ipv6' ;;
*s4*) sbyx='prefer_ipv4' ;;
*) sbyx='prefer_ipv4' ;;
esac
case "$warp" in
*x6*) xryx='ForceIPv6v4'; wxryx='ForceIPv6' ;;
*x4*) xryx='ForceIPv4v6'; wxryx='ForceIPv4' ;;
*) xryx='ForceIPv4v6'; wxryx='ForceIPv4v6' ;;
esac
elif [ "$v4_ok" = true ]; then
sbyx='ipv4_only'
xryx='ForceIPv4'
wxryx='ForceIPv4'
elif [ "$v6_ok" = true ]; then
sbyx='ipv6_only'
xryx='ForceIPv6'
wxryx='ForceIPv6'
else
sbyx='prefer_ipv4'
xryx='ForceIPv4v6'
wxryx='ForceIPv4v6'
fi
}
upxray(){
url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/xray-$cpu"; out="$HOME/agsbx/xray"; (command -v curl >/dev/null 2>&1 && curl -Lo "$out" -# --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && timeout 3 wget -O "$out" --tries=2 "$url")
chmod +x "$HOME/agsbx/xray"
sbcore=$("$HOME/agsbx/xray" version 2>/dev/null | awk '/^Xray/{print $2}')
echo "已安装Xray正式版内核：$sbcore"
}
upsingbox(){
url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/sing-box-$cpu"; out="$HOME/agsbx/sing-box"; (command -v curl>/dev/null 2>&1 && curl -Lo "$out" -# --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && timeout 3 wget -O "$out" --tries=2 "$url")
chmod +x "$HOME/agsbx/sing-box"
sbcore=$("$HOME/agsbx/sing-box" version 2>/dev/null | awk '/version/{print $NF}')
echo "已安装Sing-box正式版内核：$sbcore"
}
insuuid(){
if [ -z "$uuid" ] && [ ! -e "$HOME/agsbx/uuid" ]; then
if [ -e "$HOME/agsbx/sing-box" ]; then
uuid=$("$HOME/agsbx/sing-box" generate uuid)
else
uuid=$("$HOME/agsbx/xray" uuid)
fi
echo "$uuid" > "$HOME/agsbx/uuid"
elif [ -n "$uuid" ]; then
echo "$uuid" > "$HOME/agsbx/uuid"
fi
uuid=$(cat "$HOME/agsbx/uuid")
echo "UUID密码：$uuid"
}
installxray(){
echo
echo "=========启用xray内核========="
mkdir -p "$HOME/agsbx/xrk"
if [ ! -e "$HOME/agsbx/xray" ]; then
upxray
fi
cat > "$HOME/agsbx/xr.json" <<EOF
{
  "log": {
  "loglevel": "none"
  },
  "inbounds": [
EOF
insuuid
if [ -n "$xhp" ] || [ -n "$vlp" ]; then
if [ -z "$ym_vl_re" ]; then
ym_vl_re=apple.com
fi
echo "$ym_vl_re" > "$HOME/agsbx/ym_vl_re"
echo "Reality域名：$ym_vl_re"
if [ ! -e "$HOME/agsbx/xrk/private_key" ]; then
key_pair=$("$HOME/agsbx/xray" x25519)
private_key=$(echo "$key_pair" | grep "PrivateKey" | awk '{print $2}')
public_key=$(echo "$key_pair" | grep "Password" | awk '{print $2}')
short_id=$(date +%s%N | sha256sum | cut -c 1-8)
echo "$private_key" > "$HOME/agsbx/xrk/private_key"
echo "$public_key" > "$HOME/agsbx/xrk/public_key"
echo "$short_id" > "$HOME/agsbx/xrk/short_id"
fi
private_key_x=$(cat "$HOME/agsbx/xrk/private_key")
public_key_x=$(cat "$HOME/agsbx/xrk/public_key")
short_id_x=$(cat "$HOME/agsbx/xrk/short_id")
fi
if [ -n "$xhp" ] || [ -n "$vxp" ] || [ -n "$vwp" ]; then
if [ ! -e "$HOME/agsbx/xrk/dekey" ]; then
vlkey=$("$HOME/agsbx/xray" vlessenc)
dekey=$(echo "$vlkey" | grep '"decryption":' | sed -n '2p' | cut -d' ' -f2- | tr -d '"')
enkey=$(echo "$vlkey" | grep '"encryption":' | sed -n '2p' | cut -d' ' -f2- | tr -d '"')
echo "$dekey" > "$HOME/agsbx/xrk/dekey"
echo "$enkey" > "$HOME/agsbx/xrk/enkey"
fi
dekey=$(cat "$HOME/agsbx/xrk/dekey")
enkey=$(cat "$HOME/agsbx/xrk/enkey")
fi

if [ -n "$xhp" ]; then
xhp=xhpt
if [ -z "$port_xh" ] && [ ! -e "$HOME/agsbx/port_xh" ]; then
port_xh=$(shuf -i 10000-65535 -n 1)
echo "$port_xh" > "$HOME/agsbx/port_xh"
elif [ -n "$port_xh" ]; then
echo "$port_xh" > "$HOME/agsbx/port_xh"
fi
port_xh=$(cat "$HOME/agsbx/port_xh")
echo "Vless-xhttp-reality-enc端口：$port_xh"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"xhttp-reality",
      "listen": "::",
      "port": ${port_xh},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "reality",
        "realitySettings": {
          "fingerprint": "chrome",
          "target": "${ym_vl_re}:443",
          "serverNames": [
            "${ym_vl_re}"
          ],
          "privateKey": "$private_key_x",
          "shortIds": ["$short_id_x"]
        },
        "xhttpSettings": {
          "host": "",
          "path": "${uuid}-xh",
          "mode": "auto"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
xhp=xhptargo
fi
if [ -n "$vxp" ]; then
vxp=vxpt
if [ -z "$port_vx" ] && [ ! -e "$HOME/agsbx/port_vx" ]; then
port_vx=$(shuf -i 10000-65535 -n 1)
echo "$port_vx" > "$HOME/agsbx/port_vx"
elif [ -n "$port_vx" ]; then
echo "$port_vx" > "$HOME/agsbx/port_vx"
fi
port_vx=$(cat "$HOME/agsbx/port_vx")
echo "Vless-xhttp-enc端口：$port_vx"
if [ -n "$cdnym" ]; then
echo "$cdnym" > "$HOME/agsbx/cdnym"
echo "80系CDN或者回源CDN的host域名 (确保IP已解析在CF域名)：$cdnym"
fi
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"vless-xhttp",
      "listen": "::",
      "port": ${port_vx},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "xhttp",
        "xhttpSettings": {
          "host": "",
          "path": "${uuid}-vx",
          "mode": "auto"
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
vxp=vxptargo
fi
if [ -n "$vwp" ]; then
vwp=vwpt
if [ -z "$port_vw" ] && [ ! -e "$HOME/agsbx/port_vw" ]; then
port_vw=$(shuf -i 10000-65535 -n 1)
echo "$port_vw" > "$HOME/agsbx/port_vw"
elif [ -n "$port_vw" ]; then
echo "$port_vw" > "$HOME/agsbx/port_vw"
fi
port_vw=$(cat "$HOME/agsbx/port_vw")
echo "Vless-ws-enc端口：$port_vw"
if [ -n "$cdnym" ]; then
echo "$cdnym" > "$HOME/agsbx/cdnym"
echo "80系CDN或者回源CDN的host域名 (确保IP已解析在CF域名)：$cdnym"
fi
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"vless-ws",
      "listen": "::",
      "port": ${port_vw},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "${uuid}-vw"
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
vwp=vwptargo
fi
if [ -n "$vlp" ]; then
vlp=vlpt
if [ -z "$port_vl_re" ] && [ ! -e "$HOME/agsbx/port_vl_re" ]; then
port_vl_re=$(shuf -i 10000-65535 -n 1)
echo "$port_vl_re" > "$HOME/agsbx/port_vl_re"
elif [ -n "$port_vl_re" ]; then
echo "$port_vl_re" > "$HOME/agsbx/port_vl_re"
fi
port_vl_re=$(cat "$HOME/agsbx/port_vl_re")
echo "Vless-tcp-reality-v端口：$port_vl_re"
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
            "tag":"reality-vision",
            "listen": "::",
            "port": $port_vl_re,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "flow": "xtls-rprx-vision"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "reality",
                "realitySettings": {
                    "fingerprint": "chrome",
                    "dest": "${ym_vl_re}:443",
                    "serverNames": [
                      "${ym_vl_re}"
                    ],
                    "privateKey": "$private_key_x",
                    "shortIds": ["$short_id_x"]
                }
            },
          "sniffing": {
          "enabled": true,
          "destOverride": ["http", "tls", "quic"],
          "metadataOnly": false
      }
    },  
EOF
else
vlp=vlptargo
fi
}

installsb(){
echo
echo "=========启用Sing-box内核========="
if [ ! -e "$HOME/agsbx/sing-box" ]; then
upsingbox
fi
cat > "$HOME/agsbx/sb.json" <<EOF
{
"log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
EOF
insuuid
command -v openssl >/dev/null 2>&1 && openssl ecparam -genkey -name prime256v1 -out "$HOME/agsbx/private.key" >/dev/null 2>&1
command -v openssl >/dev/null 2>&1 && openssl req -new -x509 -days 36500 -key "$HOME/agsbx/private.key" -out "$HOME/agsbx/cert.pem" -subj "/CN=www.bing.com" >/dev/null 2>&1
if [ ! -f "$HOME/agsbx/private.key" ]; then
url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/private.key"; out="$HOME/agsbx/private.key"; (command -v curl>/dev/null 2>&1 && curl -Ls -o "$out" --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && timeout 3 wget -q -O "$out" --tries=2 "$url")
url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/cert.pem"; out="$HOME/agsbx/cert.pem"; (command -v curl>/dev/null 2>&1 && curl -Ls -o "$out" --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && timeout 3 wget -q -O "$out" --tries=2 "$url")
fi
if [ -n "$hyp" ]; then
hyp=hypt
if [ -z "$port_hy2" ] && [ ! -e "$HOME/agsbx/port_hy2" ]; then
port_hy2=$(shuf -i 10000-65535 -n 1)
echo "$port_hy2" > "$HOME/agsbx/port_hy2"
elif [ -n "$port_hy2" ]; then
echo "$port_hy2" > "$HOME/agsbx/port_hy2"
fi
port_hy2=$(cat "$HOME/agsbx/port_hy2")
echo "Hysteria2端口：$port_hy2"
cat >> "$HOME/agsbx/sb.json" <<EOF
    {
        "type": "hysteria2",
        "tag": "hy2-sb",
        "listen": "::",
        "listen_port": ${port_hy2},
        "users": [
            {
                "password": "${uuid}"
            }
        ],
        "ignore_client_bandwidth":false,
        "tls": {
            "enabled": true,
            "alpn": [
                "h3"
            ],
            "certificate_path": "$HOME/agsbx/cert.pem",
            "key_path": "$HOME/agsbx/private.key"
        }
    },
EOF
else
hyp=hyptargo
fi
if [ -n "$tup" ]; then
tup=tupt
if [ -z "$port_tu" ] && [ ! -e "$HOME/agsbx/port_tu" ]; then
port_tu=$(shuf -i 10000-65535 -n 1)
echo "$port_tu" > "$HOME/agsbx/port_tu"
elif [ -n "$port_tu" ]; then
echo "$port_tu" > "$HOME/agsbx/port_tu"
fi
port_tu=$(cat "$HOME/agsbx/port_tu")
echo "Tuic端口：$port_tu"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"tuic",
            "tag": "tuic5-sb",
            "listen": "::",
            "listen_port": ${port_tu},
            "users": [
                {
                    "uuid": "${uuid}",
                    "password": "${uuid}"
                }
            ],
            "congestion_control": "bbr",
            "tls":{
                "enabled": true,
                "alpn": [
                    "h3"
                ],
                "certificate_path": "$HOME/agsbx/cert.pem",
                "key_path": "$HOME/agsbx/private.key"
            }
        },
EOF
else
tup=tuptargo
fi
if [ -n "$anp" ]; then
anp=anpt
if [ -z "$port_an" ] && [ ! -e "$HOME/agsbx/port_an" ]; then
port_an=$(shuf -i 10000-65535 -n 1)
echo "$port_an" > "$HOME/agsbx/port_an"
elif [ -n "$port_an" ]; then
echo "$port_an" > "$HOME/agsbx/port_an"
fi
port_an=$(cat "$HOME/agsbx/port_an")
echo "Anytls端口：$port_an"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anytls-sb",
            "listen":"::",
            "listen_port":${port_an},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls":{
                "enabled": true,
                "certificate_path": "$HOME/agsbx/cert.pem",
                "key_path": "$HOME/agsbx/private.key"
            }
        },
EOF
else
anp=anptargo
fi
if [ -n "$arp" ]; then
arp=arpt
if [ -z "$ym_vl_re" ]; then
ym_vl_re=apple.com
fi
echo "$ym_vl_re" > "$HOME/agsbx/ym_vl_re"
echo "Reality域名：$ym_vl_re"
mkdir -p "$HOME/agsbx/sbk"
if [ ! -e "$HOME/agsbx/sbk/private_key" ]; then
key_pair=$("$HOME/agsbx/sing-box" generate reality-keypair)
private_key=$(echo "$key_pair" | awk '/PrivateKey/ {print $2}' | tr -d '"')
public_key=$(echo "$key_pair" | awk '/PublicKey/ {print $2}' | tr -d '"')
short_id=$("$HOME/agsbx/sing-box" generate rand --hex 4)
echo "$private_key" > "$HOME/agsbx/sbk/private_key"
echo "$public_key" > "$HOME/agsbx/sbk/public_key"
echo "$short_id" > "$HOME/agsbx/sbk/short_id"
fi
private_key_s=$(cat "$HOME/agsbx/sbk/private_key")
public_key_s=$(cat "$HOME/agsbx/sbk/public_key")
short_id_s=$(cat "$HOME/agsbx/sbk/short_id")
if [ -z "$port_ar" ] && [ ! -e "$HOME/agsbx/port_ar" ]; then
port_ar=$(shuf -i 10000-65535 -n 1)
echo "$port_ar" > "$HOME/agsbx/port_ar"
elif [ -n "$port_ar" ]; then
echo "$port_ar" > "$HOME/agsbx/port_ar"
fi
port_ar=$(cat "$HOME/agsbx/port_ar")
echo "Any-Reality端口：$port_ar"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anyreality-sb",
            "listen":"::",
            "listen_port":${port_ar},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls": {
            "enabled": true,
            "server_name": "${ym_vl_re}",
             "reality": {
              "enabled": true,
              "handshake": {
              "server": "${ym_vl_re}",
              "server_port": 443
             },
             "private_key": "$private_key_s",
             "short_id": ["$short_id_s"]
            }
          }
        },
EOF
else
arp=arptargo
fi
if [ -n "$ssp" ]; then
ssp=sspt
if [ ! -e "$HOME/agsbx/sskey" ]; then
sskey=$("$HOME/agsbx/sing-box" generate rand 16 --base64)
echo "$sskey" > "$HOME/agsbx/sskey"
fi
if [ -z "$port_ss" ] && [ ! -e "$HOME/agsbx/port_ss" ]; then
port_ss=$(shuf -i 10000-65535 -n 1)
echo "$port_ss" > "$HOME/agsbx/port_ss"
elif [ -n "$port_ss" ]; then
echo "$port_ss" > "$HOME/agsbx/port_ss"
fi
sskey=$(cat "$HOME/agsbx/sskey")
port_ss=$(cat "$HOME/agsbx/port_ss")
echo "Shadowsocks-2022端口：$port_ss"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type": "shadowsocks",
            "tag":"ss-2022",
            "listen": "::",
            "listen_port": $port_ss,
            "method": "2022-blake3-aes-128-gcm",
            "password": "$sskey"
    },  
EOF
else
ssp=ssptargo
fi
}

xrsbvm(){
if [ -n "$vmp" ]; then
vmp=vmpt
if [ -e "$HOME/agsbx/xr.json" ] && [ -n "$vmws_nodes" ]; then
> "$HOME/agsbx/vmws_ports_multi"
first_vmws_port=""
seen_vmws_ports=""
for node_port in $(echo "$vmws_nodes" | tr ',;|' '   '); do
case "$node_port" in ''|*[!0-9]*) continue ;; esac
case " $seen_vmws_ports " in *" $node_port "*) continue ;; esac
seen_vmws_ports="$seen_vmws_ports $node_port"
if [ -z "$first_vmws_port" ]; then
first_vmws_port="$node_port"
fi
echo "$node_port" >> "$HOME/agsbx/vmws_ports_multi"
echo "Vmess-ws多节点端口：$node_port"
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
            "tag": "vmess-xr-$node_port",
            "listen": "::",
            "port": ${node_port},
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                  "path": "${uuid}-vm-${node_port}"
            }
        },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
done
if [ -n "$first_vmws_port" ]; then
echo "$first_vmws_port" > "$HOME/agsbx/port_vm_ws"
port_vm_ws="$first_vmws_port"
if [ -s "$HOME/agsbx/vmws_ports_multi" ]; then
vmws_nodes=$(tr '\n' ' ' < "$HOME/agsbx/vmws_ports_multi" | xargs 2>/dev/null)
[ -n "$vmws_nodes" ] && echo "$vmws_nodes" > "$HOME/agsbx/vmws_nodes"
[ -n "$vmws_array" ] && echo "$vmws_array" > "$HOME/agsbx/vmws_array"
fi
fi
if [ -n "$cdnym" ]; then
echo "$cdnym" > "$HOME/agsbx/cdnym"
echo "80系CDN或者回源CDN的host域名 (确保IP已解析在CF域名)：$cdnym"
fi
return
fi
rm -f "$HOME/agsbx/vmws_ports_multi" "$HOME/agsbx/argo_vmws_map.log"
if [ -z "$port_vm_ws" ] && [ ! -e "$HOME/agsbx/port_vm_ws" ]; then
port_vm_ws=$(shuf -i 10000-65535 -n 1)
echo "$port_vm_ws" > "$HOME/agsbx/port_vm_ws"
elif [ -n "$port_vm_ws" ]; then
echo "$port_vm_ws" > "$HOME/agsbx/port_vm_ws"
fi
port_vm_ws=$(cat "$HOME/agsbx/port_vm_ws")
echo "Vmess-ws端口：$port_vm_ws"
if [ -n "$cdnym" ]; then
echo "$cdnym" > "$HOME/agsbx/cdnym"
echo "80系CDN或者回源CDN的host域名 (确保IP已解析在CF域名)：$cdnym"
fi
if [ -e "$HOME/agsbx/xr.json" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
            "tag": "vmess-xr",
            "listen": "::",
            "port": ${port_vm_ws},
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                  "path": "${uuid}-vm"
            }
        },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/agsbx/sb.json" <<EOF
{
        "type": "vmess",
        "tag": "vmess-sb",
        "listen": "::",
        "listen_port": ${port_vm_ws},
        "users": [
            {
                "uuid": "${uuid}",
                "alterId": 0
            }
        ],
        "transport": {
            "type": "ws",
            "path": "${uuid}-vm",
            "max_early_data":2048,
            "early_data_header_name": "Sec-WebSocket-Protocol"
        }
    },
EOF
fi
else
vmp=vmptargo
fi
}

xrsbso(){
if [ -n "$sop" ]; then
sop=sopt
if [ -z "$port_so" ] && [ ! -e "$HOME/agsbx/port_so" ]; then
port_so=$(shuf -i 10000-65535 -n 1)
echo "$port_so" > "$HOME/agsbx/port_so"
elif [ -n "$port_so" ]; then
echo "$port_so" > "$HOME/agsbx/port_so"
fi
port_so=$(cat "$HOME/agsbx/port_so")
echo "Socks5端口：$port_so"
if [ -e "$HOME/agsbx/xr.json" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
         "tag": "socks5-xr",
         "port": ${port_so},
         "listen": "::",
         "protocol": "socks",
         "settings": {
            "auth": "password",
             "accounts": [
               {
               "user": "${uuid}",
               "pass": "${uuid}"
               }
            ],
            "udp": true
          },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/agsbx/sb.json" <<EOF
    {
      "tag": "socks5-sb",
      "type": "socks",
      "listen": "::",
      "listen_port": ${port_so},
      "users": [
      {
      "username": "${uuid}",
      "password": "${uuid}"
      }
     ]
    },
EOF
fi
else
sop=soptargo
fi
}

urldecode(){
printf '%b' "$(echo "$1" | sed 's/+/ /g;s/%/\\x/g')"
}

parse_exit_vless(){
xexit_enabled=no
xexit_mode=""
xexit_tag=""

if [ "$exit_vless" = "off" ] || [ "$exit_vless" = "none" ]; then
rm -f "$HOME/agsbx/exit_vless"
exit_vless=""
fi
if [ "$exit_vmess" = "off" ] || [ "$exit_vmess" = "none" ]; then
rm -f "$HOME/agsbx/exit_vmess"
exit_vmess=""
fi
if [ "$exit_hy2" = "off" ] || [ "$exit_hy2" = "none" ]; then
rm -f "$HOME/agsbx/exit_hy2"
exit_hy2=""
fi

if [ -z "$exit_vless" ] && [ -z "$exit_vmess" ] && [ -z "$exit_hy2" ]; then
[ -e "$HOME/agsbx/exit_vless" ] && exit_vless=$(cat "$HOME/agsbx/exit_vless" 2>/dev/null)
if [ -z "$exit_vless" ]; then
[ -e "$HOME/agsbx/exit_vmess" ] && exit_vmess=$(cat "$HOME/agsbx/exit_vmess" 2>/dev/null)
fi
if [ -z "$exit_vless" ] && [ -z "$exit_vmess" ]; then
[ -e "$HOME/agsbx/exit_hy2" ] && exit_hy2=$(cat "$HOME/agsbx/exit_hy2" 2>/dev/null)
fi
fi

if [ -n "$exit_vless" ]; then
case "$exit_vless" in
vless://*) ;;
*)
echo "落地机节点参数 exvl 格式错误（必须是 vless:// 开头），已忽略"
return
;;
esac
raw_vless=${exit_vless#vless://}
raw_vless=${raw_vless%%#*}
main_vless=${raw_vless%%\?*}
query_vless=""
[ "$raw_vless" != "$main_vless" ] && query_vless=${raw_vless#*\?}
xexit_id=${main_vless%@*}
server_vless=${main_vless#*@}
xexit_addr=${server_vless%:*}
xexit_port=${server_vless##*:}
xexit_addr=${xexit_addr#\[}
xexit_addr=${xexit_addr%\]}
[ -z "$xexit_id" ] || [ -z "$xexit_addr" ] || [ -z "$xexit_port" ] && { echo "落地机节点参数 exvl 解析失败，已忽略"; return; }
xexit_encryption="none"
xexit_flow=""
xexit_security=""
xexit_sni=""
xexit_fp="chrome"
xexit_pbk=""
xexit_sid=""
if [ -n "$query_vless" ]; then
for kv in $(echo "$query_vless" | tr '&' '\n'); do
key=${kv%%=*}
val=${kv#*=}
val=$(urldecode "$val")
case "$key" in
encryption) xexit_encryption="$val" ;;
flow) xexit_flow="$val" ;;
security) xexit_security="$val" ;;
sni) xexit_sni="$val" ;;
fp) xexit_fp="$val" ;;
pbk) xexit_pbk="$val" ;;
sid) xexit_sid="$val" ;;
esac
done
fi
if [ "$xexit_security" != "reality" ]; then
echo "当前仅自动支持 VLESS-Reality 落地节点，已忽略此 exvl"
return
fi
[ -z "$xexit_pbk" ] || [ -z "$xexit_sid" ] || [ -z "$xexit_sni" ] && { echo "exvl 缺少 reality 必要参数（sni/pbk/sid），已忽略"; return; }
echo "$exit_vless" > "$HOME/agsbx/exit_vless"
rm -f "$HOME/agsbx/exit_vmess" "$HOME/agsbx/exit_hy2"
xexit_mode="vless-reality"
xexit_tag="to-exit-vless-reality"
xexit_enabled=yes
echo "落地机节点：$xexit_addr:$xexit_port (VLESS-Reality)"
return
fi

if [ -n "$exit_vmess" ]; then
case "$exit_vmess" in
vmess://*) ;;
*)
echo "落地机节点参数 exvm 格式错误（必须是 vmess:// 开头），已忽略"
return
;;
esac
xvm_raw=$(echo "${exit_vmess#vmess://}" | tr -d '\r\n ')
xvm_raw=$(echo "$xvm_raw" | tr '_-' '/+')
xvm_len=$(printf '%s' "$xvm_raw" | wc -c | tr -d ' ')
case $((xvm_len % 4)) in
2) xvm_raw="${xvm_raw}==" ;;
3) xvm_raw="${xvm_raw}=" ;;
1) echo "落地机节点参数 exvm 解析失败（Base64 长度异常），已忽略"; return ;;
esac
xvm_json=$( { printf '%s' "$xvm_raw" | base64 -d 2>/dev/null || printf '%s' "$xvm_raw" | base64 --decode 2>/dev/null; } )
[ -z "$xvm_json" ] && { echo "落地机节点参数 exvm 解码失败，已忽略"; return; }
xvm_json_one=$(echo "$xvm_json" | tr -d '\r\n')
xvm_add=$(echo "$xvm_json_one" | sed -n 's/.*"add"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
xvm_port=$(echo "$xvm_json_one" | sed -n 's/.*"port"[[:space:]]*:[[:space:]]*"\{0,1\}\([^",}]*\)"\{0,1\}.*/\1/p')
xvm_id=$(echo "$xvm_json_one" | sed -n 's/.*"id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
xvm_net=$(echo "$xvm_json_one" | sed -n 's/.*"net"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
xvm_path=$(echo "$xvm_json_one" | sed -n 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
xvm_host=$(echo "$xvm_json_one" | sed -n 's/.*"host"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
xvm_tls=$(echo "$xvm_json_one" | sed -n 's/.*"tls"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
xvm_sni=$(echo "$xvm_json_one" | sed -n 's/.*"sni"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
xvm_scy=$(echo "$xvm_json_one" | sed -n 's/.*"scy"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
[ -z "$xvm_add" ] || [ -z "$xvm_port" ] || [ -z "$xvm_id" ] && { echo "落地机节点参数 exvm 缺少 add/port/id，已忽略"; return; }
[ -z "$xvm_net" ] && xvm_net="ws"
[ -z "$xvm_path" ] && xvm_path="/"
[ -z "$xvm_scy" ] && xvm_scy="auto"
[ -z "$xvm_sni" ] && xvm_sni="$xvm_host"
echo "$exit_vmess" > "$HOME/agsbx/exit_vmess"
rm -f "$HOME/agsbx/exit_vless" "$HOME/agsbx/exit_hy2"
xexit_mode="vmess"
xexit_tag="to-exit-vmess"
xexit_enabled=yes
echo "落地机节点：$xvm_add:$xvm_port (VMess-$xvm_net)"
return
fi

if [ -n "$exit_hy2" ]; then
case "$exit_hy2" in
hysteria2://*) ;;
*)
echo "落地机节点参数 exhy2 格式错误（必须是 hysteria2:// 开头），已忽略"
return
;;
esac
xhy_raw=${exit_hy2#hysteria2://}
xhy_raw=${xhy_raw%%#*}
xhy_main=${xhy_raw%%\?*}
xhy_query=""
[ "$xhy_raw" != "$xhy_main" ] && xhy_query=${xhy_raw#*\?}
xhy_auth=${xhy_main%@*}
xhy_server=${xhy_main#*@}
xhy_addr=${xhy_server%:*}
xhy_port=${xhy_server##*:}
xhy_addr=${xhy_addr#\[}
xhy_addr=${xhy_addr%\]}
xhy_auth=$(urldecode "$xhy_auth")
xhy_security="tls"
xhy_sni=""
xhy_insecure="false"
xhy_alpn="h3"
if [ -n "$xhy_query" ]; then
for kv in $(echo "$xhy_query" | tr '&' '\n'); do
key=${kv%%=*}
val=${kv#*=}
val=$(urldecode "$val")
case "$key" in
security) xhy_security="$val" ;;
sni) xhy_sni="$val" ;;
alpn) xhy_alpn="$val" ;;
insecure|allowInsecure) [ "$val" = "1" ] || [ "$val" = "true" ] && xhy_insecure="true" ;;
auth) xhy_auth="$val" ;;
esac
done
fi
[ -z "$xhy_addr" ] || [ -z "$xhy_port" ] || [ -z "$xhy_auth" ] && { echo "落地机节点参数 exhy2 缺少 auth/addr/port，已忽略"; return; }
[ -z "$xhy_sni" ] && xhy_sni="$xhy_addr"
xhy_alpn_first=${xhy_alpn%%,*}
[ -z "$xhy_alpn_first" ] && xhy_alpn_first="h3"
echo "$exit_hy2" > "$HOME/agsbx/exit_hy2"
rm -f "$HOME/agsbx/exit_vless" "$HOME/agsbx/exit_vmess"
xexit_mode="hy2"
xexit_tag="to-exit-hy2"
xexit_enabled=yes
echo "落地机节点：$xhy_addr:$xhy_port (Hysteria2)"
fi
}

list_to_json_array(){
input_list="$1"
json_out=""
for item in $(echo "$input_list" | tr ',;|' '   '); do
[ -n "$item" ] || continue
item_esc=$(printf '%s' "$item" | sed 's/"/\\"/g')
if [ -z "$json_out" ]; then
json_out="\"$item_esc\""
else
json_out="$json_out, \"$item_esc\""
fi
done
echo "$json_out"
}

list_to_xray_domain_array(){
input_list="$1"
json_out=""
for item in $(echo "$input_list" | tr ',;|' '   '); do
[ -n "$item" ] || continue
case "$item" in
domain:*|full:*|regexp:*|keyword:*|geosite:*|geoip:*) matcher="$item" ;;
*) matcher="domain:$item" ;;
esac
matcher_esc=$(printf '%s' "$matcher" | sed 's/"/\\"/g')
if [ -z "$json_out" ]; then
json_out="\"$matcher_esc\""
else
json_out="$json_out, \"$matcher_esc\""
fi
done
echo "$json_out"
}

normalize_ruleset_name(){
raw_name="$1"
raw_name=${raw_name#geosite:}
raw_name=${raw_name#geosite-}
echo "$raw_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9._-]//g'
}

append_singbox_ruleset_def(){
rs_name="$1"
rs_tag="geosite-$rs_name"
case " $sb_ruleset_seen " in
*" $rs_tag "*) return ;;
esac
sb_ruleset_seen="$sb_ruleset_seen $rs_tag"
if [ -z "$sb_ruleset_defs" ]; then
sb_ruleset_defs=$(cat <<EOF
      {
        "tag": "$rs_tag",
        "type": "remote",
        "format": "binary",
        "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/$rs_name.srs",
        "download_detour": "direct"
      }
EOF
)
else
sb_ruleset_defs="$sb_ruleset_defs,
$(cat <<EOF
      {
        "tag": "$rs_tag",
        "type": "remote",
        "format": "binary",
        "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/$rs_name.srs",
        "download_detour": "direct"
      }
EOF
)"
fi
}

download_if_missing(){
dl_target="$1"
shift
[ -s "$dl_target" ] && return 0
dl_tmp="${dl_target}.tmp.$$"
rm -f "$dl_tmp"
for dl_url in "$@"; do
[ -n "$dl_url" ] || continue
if command -v curl >/dev/null 2>&1; then
curl -fsL --connect-timeout 8 --max-time 40 -o "$dl_tmp" "$dl_url" >/dev/null 2>&1
elif command -v wget >/dev/null 2>&1; then
timeout 45 wget -qO "$dl_tmp" --tries=2 "$dl_url" >/dev/null 2>&1
else
return 1
fi
if [ -s "$dl_tmp" ]; then
mv "$dl_tmp" "$dl_target"
chmod 644 "$dl_target" 2>/dev/null
return 0
fi
rm -f "$dl_tmp"
done
rm -f "$dl_tmp"
return 1
}

ensure_xray_geo_data(){
[ -s "$HOME/agsbx/xr.json" ] || return
grep -q 'geosite:' "$HOME/agsbx/xr.json" 2>/dev/null || return
download_if_missing "$HOME/agsbx/geosite.dat" \
"https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" \
"https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat"
download_if_missing "$HOME/agsbx/geoip.dat" \
"https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" \
"https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat"
if [ ! -s "$HOME/agsbx/geosite.dat" ]; then
echo "Warning: geosite.dat is missing; geosite rules may fail"
fi
}

parse_exit_url_to_outbound(){
p_url="$1"
p_tag="$2"
parsed_exit_outbound_json=""
case "$p_url" in
vless://*)
p_raw=${p_url#vless://}
p_raw=${p_raw%%#*}
p_main=${p_raw%%\?*}
p_query=""
[ "$p_raw" != "$p_main" ] && p_query=${p_raw#*\?}
p_id=${p_main%@*}
p_server=${p_main#*@}
p_addr=${p_server%:*}
p_port=${p_server##*:}
p_addr=${p_addr#\[}
p_addr=${p_addr%\]}
[ -n "$p_id" ] && [ -n "$p_addr" ] && [ -n "$p_port" ] || return 1
p_encryption="none"
p_flow=""
p_security=""
p_sni=""
p_fp="chrome"
p_pbk=""
p_sid=""
if [ -n "$p_query" ]; then
for kv in $(echo "$p_query" | tr '&' '\n'); do
key=${kv%%=*}
val=${kv#*=}
val=$(urldecode "$val")
case "$key" in
encryption) p_encryption="$val" ;;
flow) p_flow="$val" ;;
security) p_security="$val" ;;
sni) p_sni="$val" ;;
fp) p_fp="$val" ;;
pbk) p_pbk="$val" ;;
sid) p_sid="$val" ;;
esac
done
fi
[ "$p_security" = "reality" ] || return 1
[ -n "$p_pbk" ] && [ -n "$p_sid" ] && [ -n "$p_sni" ] || return 1
parsed_exit_outbound_json=$(cat <<EOF
    ,
    {
      "tag": "$p_tag",
      "protocol": "vless",
      "settings": {
        "vnext": [
          {
            "address": "$p_addr",
            "port": $p_port,
            "users": [
              {
                "id": "$p_id",
                "encryption": "$p_encryption",
                "flow": "$p_flow"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "serverName": "$p_sni",
          "fingerprint": "$p_fp",
          "publicKey": "$p_pbk",
          "shortId": "$p_sid",
          "spiderX": "/"
        }
      }
    }
EOF
)
return 0
;;
vmess://*)
p_raw=$(echo "${p_url#vmess://}" | tr -d '\r\n ')
p_raw=$(echo "$p_raw" | tr '_-' '/+')
p_len=$(printf '%s' "$p_raw" | wc -c | tr -d ' ')
case $((p_len % 4)) in
2) p_raw="${p_raw}==" ;;
3) p_raw="${p_raw}=" ;;
1) return 1 ;;
esac
p_json=$( { printf '%s' "$p_raw" | base64 -d 2>/dev/null || printf '%s' "$p_raw" | base64 --decode 2>/dev/null; } )
[ -n "$p_json" ] || return 1
p_one=$(echo "$p_json" | tr -d '\r\n')
p_add=$(echo "$p_one" | sed -n 's/.*"add"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
p_port=$(echo "$p_one" | sed -n 's/.*"port"[[:space:]]*:[[:space:]]*"\{0,1\}\([^",}]*\)"\{0,1\}.*/\1/p')
p_id=$(echo "$p_one" | sed -n 's/.*"id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
p_net=$(echo "$p_one" | sed -n 's/.*"net"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
p_path=$(echo "$p_one" | sed -n 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
p_host=$(echo "$p_one" | sed -n 's/.*"host"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
p_tls=$(echo "$p_one" | sed -n 's/.*"tls"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
p_sni=$(echo "$p_one" | sed -n 's/.*"sni"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
p_scy=$(echo "$p_one" | sed -n 's/.*"scy"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
[ -n "$p_add" ] && [ -n "$p_port" ] && [ -n "$p_id" ] || return 1
[ -n "$p_net" ] || p_net="ws"
[ -n "$p_path" ] || p_path="/"
[ -n "$p_scy" ] || p_scy="auto"
[ -n "$p_sni" ] || p_sni="$p_host"
if [ "$p_net" = "ws" ] && [ "$p_tls" = "tls" ]; then
parsed_exit_outbound_json=$(cat <<EOF
    ,
    {
      "tag": "$p_tag",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "$p_add",
            "port": $p_port,
            "users": [
              {
                "id": "$p_id",
                "security": "$p_scy"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "serverName": "$p_sni"
        },
        "wsSettings": {
          "path": "$p_path",
          "headers": {
            "Host": "$p_host"
          }
        }
      }
    }
EOF
)
elif [ "$p_net" = "ws" ]; then
parsed_exit_outbound_json=$(cat <<EOF
    ,
    {
      "tag": "$p_tag",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "$p_add",
            "port": $p_port,
            "users": [
              {
                "id": "$p_id",
                "security": "$p_scy"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "$p_path",
          "headers": {
            "Host": "$p_host"
          }
        }
      }
    }
EOF
)
else
parsed_exit_outbound_json=$(cat <<EOF
    ,
    {
      "tag": "$p_tag",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "$p_add",
            "port": $p_port,
            "users": [
              {
                "id": "$p_id",
                "security": "$p_scy"
              }
            ]
          }
        ]
      }
    }
EOF
)
fi
return 0
;;
hysteria2://*)
p_raw=${p_url#hysteria2://}
p_raw=${p_raw%%#*}
p_main=${p_raw%%\?*}
p_query=""
[ "$p_raw" != "$p_main" ] && p_query=${p_raw#*\?}
p_auth=${p_main%@*}
p_server=${p_main#*@}
p_addr=${p_server%:*}
p_port=${p_server##*:}
p_addr=${p_addr#\[}
p_addr=${p_addr%\]}
p_auth=$(urldecode "$p_auth")
p_security="tls"
p_sni=""
p_insecure="false"
p_alpn="h3"
if [ -n "$p_query" ]; then
for kv in $(echo "$p_query" | tr '&' '\n'); do
key=${kv%%=*}
val=${kv#*=}
val=$(urldecode "$val")
case "$key" in
security) p_security="$val" ;;
sni) p_sni="$val" ;;
alpn) p_alpn="$val" ;;
insecure|allowInsecure) [ "$val" = "1" ] || [ "$val" = "true" ] && p_insecure="true" ;;
auth) p_auth="$val" ;;
esac
done
fi
[ -n "$p_addr" ] && [ -n "$p_port" ] && [ -n "$p_auth" ] || return 1
[ -n "$p_sni" ] || p_sni="$p_addr"
p_alpn_first=${p_alpn%%,*}
[ -n "$p_alpn_first" ] || p_alpn_first="h3"
if [ "$p_security" = "tls" ]; then
parsed_exit_outbound_json=$(cat <<EOF
    ,
    {
      "tag": "$p_tag",
      "protocol": "hysteria",
      "settings": {
        "version": 2,
        "address": "$p_addr",
        "port": $p_port
      },
      "streamSettings": {
        "network": "hysteria",
        "security": "tls",
        "tlsSettings": {
          "serverName": "$p_sni",
          "allowInsecure": $p_insecure,
          "alpn": ["$p_alpn_first"]
        },
        "hysteriaSettings": {
          "version": 2,
          "auth": "$p_auth"
        }
      }
    }
EOF
)
else
parsed_exit_outbound_json=$(cat <<EOF
    ,
    {
      "tag": "$p_tag",
      "protocol": "hysteria",
      "settings": {
        "version": 2,
        "address": "$p_addr",
        "port": $p_port
      },
      "streamSettings": {
        "network": "hysteria",
        "security": "none",
        "hysteriaSettings": {
          "version": 2,
          "auth": "$p_auth"
        }
      }
    }
EOF
)
fi
return 0
;;
esac
return 1
}

build_multi_vmws_route_blocks(){
multi_vmws_pre_rules=""
multi_vmws_main_rules=""
multi_vmws_outbounds=""
[ -s "$HOME/agsbx/vmws_ports_multi" ] || return
while IFS= read -r node_port; do
[ -n "$node_port" ] || continue
case "$node_port" in *[!0-9]*) continue ;; esac
node_inbound_tag="vmess-xr-$node_port"
node_exit_tag=""
read_vmws_node_cfg "$node_port"
eval "node_exvl_set=\${exvl_${node_port}+set}"
eval "node_exvm_set=\${exvm_${node_port}+set}"
eval "node_exhy2_set=\${exhy2_${node_port}+set}"
eval "node_xwd_set=\${xwd_${node_port}+set}"
eval "node_xws_set=\${xws_${node_port}+set}"
eval "node_exvl=\${exvl_${node_port}:-}"
eval "node_exvm=\${exvm_${node_port}:-}"
eval "node_exhy2=\${exhy2_${node_port}:-}"
eval "node_xwd=\${xwd_${node_port}:-}"
eval "node_xws=\${xws_${node_port}:-}"
if [ "$node_exvl_set" = set ]; then
node_exvl=$(normalize_disable_value "$node_exvl")
else
node_exvl="$node_cfg_exvl"
fi
if [ "$node_exvm_set" = set ]; then
node_exvm=$(normalize_disable_value "$node_exvm")
else
node_exvm="$node_cfg_exvm"
fi
if [ "$node_exhy2_set" = set ]; then
node_exhy2=$(normalize_disable_value "$node_exhy2")
else
node_exhy2="$node_cfg_exhy2"
fi
if [ "$node_xwd_set" = set ]; then
node_xwd=$(normalize_disable_value "$node_xwd")
else
node_xwd="$node_cfg_xwd"
fi
if [ "$node_xws_set" = set ]; then
node_xws=$(normalize_disable_value "$node_xws")
else
node_xws="$node_cfg_xws"
fi
node_cfg_exvl="$node_exvl"
node_cfg_exvm="$node_exvm"
node_cfg_exhy2="$node_exhy2"
node_cfg_xwd="$node_xwd"
node_cfg_xws="$node_xws"
write_vmws_node_cfg "$node_port"
if [ -n "$node_exvl" ]; then
node_exit_url="$node_exvl"
elif [ -n "$node_exvm" ]; then
node_exit_url="$node_exvm"
elif [ -n "$node_exhy2" ]; then
node_exit_url="$node_exhy2"
else
node_exit_url=""
fi
if [ -n "$node_exit_url" ]; then
node_exit_tag="to-exit-node-$node_port"
if parse_exit_url_to_outbound "$node_exit_url" "$node_exit_tag"; then
multi_vmws_outbounds="${multi_vmws_outbounds}${parsed_exit_outbound_json}"
else
node_exit_tag=""
fi
fi
node_xwd_json=$(list_to_xray_domain_array "$node_xwd")
if [ -n "$node_xwd_json" ]; then
multi_vmws_pre_rules="$multi_vmws_pre_rules
$(cat <<EOF
      {
        "type": "field",
        "inboundTag": ["$node_inbound_tag"],
        "domain": [ $node_xwd_json ],
        "network": "tcp,udp",
        "outboundTag": "warp-out"
      },
EOF
)"
fi
node_xws_json=""
for raw_item in $(echo "$node_xws" | tr ',;|' '   '); do
rs_name=$(normalize_ruleset_name "$raw_item")
[ -n "$rs_name" ] || continue
if [ -z "$node_xws_json" ]; then
node_xws_json="\"geosite:$rs_name\""
else
node_xws_json="$node_xws_json, \"geosite:$rs_name\""
fi
done
if [ -n "$node_xws_json" ]; then
multi_vmws_pre_rules="$multi_vmws_pre_rules
$(cat <<EOF
      {
        "type": "field",
        "inboundTag": ["$node_inbound_tag"],
        "domain": [ $node_xws_json ],
        "network": "tcp,udp",
        "outboundTag": "warp-out"
      },
EOF
)"
fi
if [ -n "$node_exit_tag" ]; then
node_target_out="$node_exit_tag"
elif [ "$xexit_enabled" = yes ]; then
node_target_out="$xexit_tag"
else
node_target_out=""
fi
if [ -n "$node_target_out" ]; then
multi_vmws_main_rules="$multi_vmws_main_rules
$(cat <<EOF
      {
        "type": "field",
        "inboundTag": ["$node_inbound_tag"],
        "network": "tcp,udp",
        "outboundTag": "$node_target_out"
      },
EOF
)"
fi
done < "$HOME/agsbx/vmws_ports_multi"
}

build_route_rule_blocks(){
xr_pre_exit_rules=""
xr_extra_rules=""
sb_extra_rules=""
sb_rule_set_block=""
sb_ruleset_defs=""
sb_ruleset_seen=""
sb_warp_ruleset_tags=""
sb_direct_ruleset_tags=""
xr_warp_geosite_domains=""
xr_direct_geosite_domains=""
xexit_warp_geosite_domains=""

sb_warp_domain_json=$(list_to_json_array "$warp_domain_suffix")
sb_direct_domain_json=$(list_to_json_array "$direct_domain_suffix")
xr_warp_domain_json=$(list_to_xray_domain_array "$warp_domain_suffix")
xr_direct_domain_json=$(list_to_xray_domain_array "$direct_domain_suffix")
xexit_warp_domain_json=$(list_to_xray_domain_array "$exit_warp_domain_suffix")

if [ -n "$xexit_warp_domain_json" ]; then
xr_pre_exit_rules="$xr_pre_exit_rules
$(cat <<EOF
      {
        "type": "field",
        "inboundTag": ["vmess-xr", "vless-ws", "vless-xhttp", "xhttp-reality", "reality-vision"],
        "domain": [ $xexit_warp_domain_json ],
        "network": "tcp,udp",
        "outboundTag": "warp-out"
      },
EOF
)"
fi

if [ -n "$xr_warp_domain_json" ]; then
xr_extra_rules="$xr_extra_rules
$(cat <<EOF
      {
        "type": "field",
        "domain": [ $xr_warp_domain_json ],
        "network": "tcp,udp",
        "outboundTag": "warp-out"
      },
EOF
)"
fi
if [ -n "$xr_direct_domain_json" ]; then
xr_extra_rules="$xr_extra_rules
$(cat <<EOF
      {
        "type": "field",
        "domain": [ $xr_direct_domain_json ],
        "network": "tcp,udp",
        "outboundTag": "direct"
      },
EOF
)"
fi
if [ -n "$sb_warp_domain_json" ]; then
sb_extra_rules="$sb_extra_rules
$(cat <<EOF
      {
        "domain_suffix": [ $sb_warp_domain_json ],
        "outbound": "warp-out"
      },
EOF
)"
fi
if [ -n "$sb_direct_domain_json" ]; then
sb_extra_rules="$sb_extra_rules
$(cat <<EOF
      {
        "domain_suffix": [ $sb_direct_domain_json ],
        "outbound": "direct"
      },
EOF
)"
fi

for raw_item in $(echo "$warp_rule_set" | tr ',;|' '   '); do
rs_name=$(normalize_ruleset_name "$raw_item")
[ -n "$rs_name" ] || continue
append_singbox_ruleset_def "$rs_name"
rs_tag="geosite-$rs_name"
if [ -z "$sb_warp_ruleset_tags" ]; then
sb_warp_ruleset_tags="\"$rs_tag\""
else
sb_warp_ruleset_tags="$sb_warp_ruleset_tags, \"$rs_tag\""
fi
if [ -z "$xr_warp_geosite_domains" ]; then
xr_warp_geosite_domains="\"geosite:$rs_name\""
else
xr_warp_geosite_domains="$xr_warp_geosite_domains, \"geosite:$rs_name\""
fi
done

for raw_item in $(echo "$direct_rule_set" | tr ',;|' '   '); do
rs_name=$(normalize_ruleset_name "$raw_item")
[ -n "$rs_name" ] || continue
append_singbox_ruleset_def "$rs_name"
rs_tag="geosite-$rs_name"
if [ -z "$sb_direct_ruleset_tags" ]; then
sb_direct_ruleset_tags="\"$rs_tag\""
else
sb_direct_ruleset_tags="$sb_direct_ruleset_tags, \"$rs_tag\""
fi
if [ -z "$xr_direct_geosite_domains" ]; then
xr_direct_geosite_domains="\"geosite:$rs_name\""
else
xr_direct_geosite_domains="$xr_direct_geosite_domains, \"geosite:$rs_name\""
fi
done

for raw_item in $(echo "$exit_warp_rule_set" | tr ',;|' '   '); do
rs_name=$(normalize_ruleset_name "$raw_item")
[ -n "$rs_name" ] || continue
if [ -z "$xexit_warp_geosite_domains" ]; then
xexit_warp_geosite_domains="\"geosite:$rs_name\""
else
xexit_warp_geosite_domains="$xexit_warp_geosite_domains, \"geosite:$rs_name\""
fi
done

if [ -n "$xexit_warp_geosite_domains" ]; then
xr_pre_exit_rules="$xr_pre_exit_rules
$(cat <<EOF
      {
        "type": "field",
        "inboundTag": ["vmess-xr", "vless-ws", "vless-xhttp", "xhttp-reality", "reality-vision"],
        "domain": [ $xexit_warp_geosite_domains ],
        "network": "tcp,udp",
        "outboundTag": "warp-out"
      },
EOF
)"
fi

if [ -n "$xr_warp_geosite_domains" ]; then
xr_extra_rules="$xr_extra_rules
$(cat <<EOF
      {
        "type": "field",
        "domain": [ $xr_warp_geosite_domains ],
        "network": "tcp,udp",
        "outboundTag": "warp-out"
      },
EOF
)"
fi
if [ -n "$xr_direct_geosite_domains" ]; then
xr_extra_rules="$xr_extra_rules
$(cat <<EOF
      {
        "type": "field",
        "domain": [ $xr_direct_geosite_domains ],
        "network": "tcp,udp",
        "outboundTag": "direct"
      },
EOF
)"
fi
if [ -n "$sb_warp_ruleset_tags" ]; then
sb_extra_rules="$sb_extra_rules
$(cat <<EOF
      {
        "rule_set": [ $sb_warp_ruleset_tags ],
        "outbound": "warp-out"
      },
EOF
)"
fi
if [ -n "$sb_direct_ruleset_tags" ]; then
sb_extra_rules="$sb_extra_rules
$(cat <<EOF
      {
        "rule_set": [ $sb_direct_ruleset_tags ],
        "outbound": "direct"
      },
EOF
)"
fi

if [ -n "$sb_ruleset_defs" ]; then
sb_rule_set_block=$(cat <<EOF
    "rule_set": [
$sb_ruleset_defs
    ],
EOF
)
fi
}

xrsbout(){
build_route_rule_blocks
if [ -e "$HOME/agsbx/xr.json" ]; then
parse_exit_vless
build_multi_vmws_route_blocks
sed -i '${s/,\s*$//}' "$HOME/agsbx/xr.json"
cat >> "$HOME/agsbx/xr.json" <<EOF
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct",
      "settings": {
      "domainStrategy":"${xryx}"
     }
    },
    {
      "tag": "x-warp-out",
      "protocol": "wireguard",
      "settings": {
        "secretKey": "${pvk}",
        "address": [
          "172.16.0.2/32",
          "${wpv6}/128"
        ],
        "peers": [
          {
            "publicKey": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
            "allowedIPs": [
              "0.0.0.0/0",
              "::/0"
            ],
            "endpoint": "${xendip}:2408"
          }
        ],
        "reserved": ${res}
        }
    },
    {
      "tag":"warp-out",
      "protocol":"freedom",
        "settings":{
        "domainStrategy":"${wxryx}"
       },
       "proxySettings":{
       "tag":"x-warp-out"
     }
}
EOF
if [ "$xexit_enabled" = yes ]; then
if [ "$xexit_mode" = "vless-reality" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
    ,
    {
      "tag": "${xexit_tag}",
      "protocol": "vless",
      "settings": {
        "vnext": [
          {
            "address": "${xexit_addr}",
            "port": ${xexit_port},
            "users": [
              {
                "id": "${xexit_id}",
                "encryption": "${xexit_encryption}",
                "flow": "${xexit_flow}"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "serverName": "${xexit_sni}",
          "fingerprint": "${xexit_fp}",
          "publicKey": "${xexit_pbk}",
          "shortId": "${xexit_sid}",
          "spiderX": "/"
        }
      }
    }
EOF
elif [ "$xexit_mode" = "vmess" ]; then
if [ "$xvm_net" = "ws" ] && [ "$xvm_tls" = "tls" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
    ,
    {
      "tag": "${xexit_tag}",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "${xvm_add}",
            "port": ${xvm_port},
            "users": [
              {
                "id": "${xvm_id}",
                "security": "${xvm_scy}"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "serverName": "${xvm_sni}"
        },
        "wsSettings": {
          "path": "${xvm_path}",
          "headers": {
            "Host": "${xvm_host}"
          }
        }
      }
    }
EOF
elif [ "$xvm_net" = "ws" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
    ,
    {
      "tag": "${xexit_tag}",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "${xvm_add}",
            "port": ${xvm_port},
            "users": [
              {
                "id": "${xvm_id}",
                "security": "${xvm_scy}"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "${xvm_path}",
          "headers": {
            "Host": "${xvm_host}"
          }
        }
      }
    }
EOF
else
cat >> "$HOME/agsbx/xr.json" <<EOF
    ,
    {
      "tag": "${xexit_tag}",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "${xvm_add}",
            "port": ${xvm_port},
            "users": [
              {
                "id": "${xvm_id}",
                "security": "${xvm_scy}"
              }
            ]
          }
        ]
      }
    }
EOF
fi
elif [ "$xexit_mode" = "hy2" ]; then
if [ "$xhy_security" = "tls" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
    ,
    {
      "tag": "${xexit_tag}",
      "protocol": "hysteria",
      "settings": {
        "version": 2,
        "address": "${xhy_addr}",
        "port": ${xhy_port}
      },
      "streamSettings": {
        "network": "hysteria",
        "security": "tls",
        "tlsSettings": {
          "serverName": "${xhy_sni}",
          "allowInsecure": ${xhy_insecure},
          "alpn": ["${xhy_alpn_first}"]
        },
        "hysteriaSettings": {
          "version": 2,
          "auth": "${xhy_auth}"
        }
      }
    }
EOF
else
cat >> "$HOME/agsbx/xr.json" <<EOF
    ,
    {
      "tag": "${xexit_tag}",
      "protocol": "hysteria",
      "settings": {
        "version": 2,
        "address": "${xhy_addr}",
        "port": ${xhy_port}
      },
      "streamSettings": {
        "network": "hysteria",
        "security": "none",
        "hysteriaSettings": {
          "version": 2,
          "auth": "${xhy_auth}"
        }
      }
    }
EOF
fi
fi
fi
if [ -n "$multi_vmws_outbounds" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
${multi_vmws_outbounds}
EOF
fi
cat >> "$HOME/agsbx/xr.json" <<EOF
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
EOF
if [ "$xexit_enabled" = yes ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
${xr_pre_exit_rules}
      {
        "type": "field",
        "inboundTag": ["vmess-xr", "vless-ws", "vless-xhttp", "xhttp-reality", "reality-vision"],
        "network": "tcp,udp",
        "outboundTag": "${xexit_tag}"
      },
EOF
fi
cat >> "$HOME/agsbx/xr.json" <<EOF
${multi_vmws_pre_rules}
${multi_vmws_main_rules}
${xr_extra_rules}
      {
        "type": "field",
        "ip": [ ${xip} ],
        "network": "tcp,udp",
        "outboundTag": "${x1outtag}"
      },
      {
        "type": "field",
        "network": "tcp,udp",
        "outboundTag": "${x2outtag}"
      }
    ]
  }
}
EOF
ensure_xray_geo_data
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/xr.service <<EOF
[Unit]
Description=xr service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=/root/agsbx/xray run -c /root/agsbx/xr.json
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable xr >/dev/null 2>&1
systemctl start xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/xray <<EOF
#!/sbin/openrc-run
description="xr service"
command="/root/agsbx/xray"
command_args="run -c /root/agsbx/xr.json"
command_background=yes
pidfile="/run/xray.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/xray >/dev/null 2>&1
rc-update add xray default >/dev/null 2>&1
rc-service xray start >/dev/null 2>&1
else
nohup "$HOME/agsbx/xray" run -c "$HOME/agsbx/xr.json" >/dev/null 2>&1 &
fi
fi
if [ -e "$HOME/agsbx/sb.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/agsbx/sb.json"
cat >> "$HOME/agsbx/sb.json" <<EOF
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "endpoints": [
    {
      "type": "wireguard",
      "tag": "warp-out",
      "address": [
        "172.16.0.2/32",
        "${wpv6}/128"
      ],
      "private_key": "${pvk}",
      "peers": [
        {
          "address": "${sendip}",
          "port": 2408,
          "public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
          "allowed_ips": [
            "0.0.0.0/0",
            "::/0"
          ],
          "reserved": $res
        }
      ]
    }
  ],
  "route": {
    "rules": [
       {
          "action": "sniff"
        },
       {
        "action": "resolve",
         "strategy": "${sbyx}"
       },
${sb_extra_rules}
      {
        "ip_cidr": [ ${sip} ],         
        "outbound": "${s1outtag}"
      }
    ],
${sb_rule_set_block}
    "final": "${s2outtag}"
  }
}
EOF
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/sb.service <<EOF
[Unit]
Description=sb service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=/root/agsbx/sing-box run -c /root/agsbx/sb.json
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable sb >/dev/null 2>&1
systemctl start sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/sing-box <<EOF
#!/sbin/openrc-run
description="sb service"
command="/root/agsbx/sing-box"
command_args="run -c /root/agsbx/sb.json"
command_background=yes
pidfile="/run/sing-box.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/sing-box >/dev/null 2>&1
rc-update add sing-box default >/dev/null 2>&1
rc-service sing-box start >/dev/null 2>&1
else
nohup "$HOME/agsbx/sing-box" run -c "$HOME/agsbx/sb.json" >/dev/null 2>&1 &
fi
fi
}

start_multi_vmws_argo_temp(){
[ -s "$HOME/agsbx/vmws_ports_multi" ] || return 1
rm -f "$HOME/agsbx/argo_vmws_map.log"
while IFS= read -r vmws_port; do
[ -n "$vmws_port" ] || continue
nohup "$HOME/agsbx/cloudflared" tunnel --url "http://localhost:${vmws_port}" --edge-ip-version auto --no-autoupdate --protocol http2 > "$HOME/agsbx/argo-${vmws_port}.log" 2>&1 &
done < "$HOME/agsbx/vmws_ports_multi"
sleep 8
ok_multi_argo=no
while IFS= read -r vmws_port; do
[ -n "$vmws_port" ] || continue
vmws_domain=$(grep -a trycloudflare.com "$HOME/agsbx/argo-${vmws_port}.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
if [ -n "$vmws_domain" ]; then
echo "${vmws_port}|${vmws_domain}" >> "$HOME/agsbx/argo_vmws_map.log"
ok_multi_argo=yes
fi
done < "$HOME/agsbx/vmws_ports_multi"
[ "$ok_multi_argo" = yes ]
}

build_multi_vmws_argo_fixed_map(){
[ -s "$HOME/agsbx/vmws_ports_multi" ] || return 1
[ -n "$ARGO_DOMAIN" ] || return 1
domain_items=""
for d in $(echo "$ARGO_DOMAIN" | tr ',;|' '   '); do
[ -n "$d" ] || continue
domain_items="$domain_items $d"
done
domain_items=$(echo "$domain_items" | xargs 2>/dev/null)
[ -n "$domain_items" ] || return 1
domain_first=$(echo "$domain_items" | awk '{print $1}')
[ -n "$domain_first" ] || return 1
rm -f "$HOME/agsbx/argo_vmws_map.log"
domain_idx=1
while IFS= read -r vmws_port; do
[ -n "$vmws_port" ] || continue
case "$vmws_port" in *[!0-9]*) continue ;; esac
domain_pick=$(echo "$domain_items" | awk -v idx="$domain_idx" '{ if (idx<=NF) print $idx; else print $1 }')
[ -n "$domain_pick" ] || domain_pick="$domain_first"
echo "${vmws_port}|${domain_pick}" >> "$HOME/agsbx/argo_vmws_map.log"
domain_idx=$((domain_idx + 1))
done < "$HOME/agsbx/vmws_ports_multi"
[ -s "$HOME/agsbx/argo_vmws_map.log" ] || return 1
echo "$domain_first" > "$HOME/agsbx/sbargoym.log"
return 0
}

ins(){
if [ "$hyp" != yes ] && [ "$tup" != yes ] && [ "$anp" != yes ] && [ "$arp" != yes ] && [ "$ssp" != yes ]; then
installxray
xrsbvm
xrsbso
warpsx
xrsbout
hyp="hyptargo"; tup="tuptargo"; anp="anptargo"; arp="arptargo"; ssp="ssptargo"
elif [ "$xhp" != yes ] && [ "$vlp" != yes ] && [ "$vxp" != yes ] && [ "$vwp" != yes ]; then
installsb
xrsbvm
xrsbso
warpsx
xrsbout
xhp="xhptargo"; vlp="vlptargo"; vxp="vxptargo"; vwp="vwptargo"
else
installsb
installxray
xrsbvm
xrsbso
warpsx
xrsbout
fi
if [ -n "$argo" ] && [ -n "$vmag" ]; then
echo
echo "=========启用Cloudflared-argo内核========="
if [ ! -e "$HOME/agsbx/cloudflared" ]; then
argocore=$({ command -v curl >/dev/null 2>&1 && curl -Ls https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared || wget -qO- https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared; } | grep -Eo '"[0-9.]+"' | sed -n 1p | tr -d '",')
echo "下载Cloudflared-argo最新正式版内核：$argocore"
url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu"; out="$HOME/agsbx/cloudflared"; (command -v curl>/dev/null 2>&1 && curl -Lo "$out" -# --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && timeout 3 wget -O "$out" --tries=2 "$url")
chmod +x "$HOME/agsbx/cloudflared"
fi
argo_multi_vmws=no
if [ "$argo" = "vmpt" ]; then
echo "Vmess" > "$HOME/agsbx/vlvm"
if [ -s "$HOME/agsbx/vmws_ports_multi" ]; then
argo_multi_vmws=yes
argoport=$(head -n1 "$HOME/agsbx/vmws_ports_multi" 2>/dev/null)
else
argoport=$(cat "$HOME/agsbx/port_vm_ws" 2>/dev/null)
fi
elif [ "$argo" = "vwpt" ]; then
argoport=$(cat "$HOME/agsbx/port_vw" 2>/dev/null)
echo "Vless" > "$HOME/agsbx/vlvm"
fi
echo "$argoport" > "$HOME/agsbx/argoport.log"
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
if [ "$argo_multi_vmws" = yes ]; then
echo "Tips: multi-vmws with fixed token supports multiple domains in agn (split by space/comma, matched by port order)."
fi
argoname='固定'
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/argo.service <<EOF
[Unit]
Description=argo service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=/root/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "${ARGO_AUTH}"
Restart=on-failure
RestartSec=5s
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable argo >/dev/null 2>&1
systemctl start argo >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/argo <<EOF
#!/sbin/openrc-run
description="argo service"
command="/root/agsbx/cloudflared tunnel"
command_args="--no-autoupdate --edge-ip-version auto --protocol http2 run --token ${ARGO_AUTH}"
pidfile="/run/argo.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/argo >/dev/null 2>&1
rc-update add argo default >/dev/null 2>&1
rc-service argo start >/dev/null 2>&1
else
nohup "$HOME/agsbx/cloudflared" tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "${ARGO_AUTH}" >/dev/null 2>&1 &
fi
if [ "$argo_multi_vmws" = yes ]; then
if ! build_multi_vmws_argo_fixed_map; then
echo "${ARGO_DOMAIN}" > "$HOME/agsbx/sbargoym.log"
fi
else
rm -f "$HOME/agsbx/argo_vmws_map.log"
echo "${ARGO_DOMAIN}" > "$HOME/agsbx/sbargoym.log"
fi
echo "${ARGO_AUTH}" > "$HOME/agsbx/sbargotoken.log"
else
argoname='临时'
if [ "$argo_multi_vmws" = yes ]; then
start_multi_vmws_argo_temp
else
nohup "$HOME/agsbx/cloudflared" tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &
fi
fi
echo "申请Argo$argoname隧道中……请稍等"
sleep 8
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
argodomain=$(cat "$HOME/agsbx/sbargoym.log" 2>/dev/null)
elif [ "$argo_multi_vmws" = yes ]; then
argodomain=$(awk -F'|' 'NR==1{print $2}' "$HOME/agsbx/argo_vmws_map.log" 2>/dev/null)
else
argodomain=$(grep -a trycloudflare.com "$HOME/agsbx/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
fi
if [ -n "${argodomain}" ]; then
echo "Argo$argoname隧道申请成功"
else
echo "Argo$argoname隧道申请失败，请稍后再试"
fi
fi
sleep 5
echo
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' || pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1 ; then
[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/agsbx/d' ~/.bashrc
SCRIPT_PATH="$HOME/bin/agsbx"
mkdir -p "$HOME/bin"
(command -v curl >/dev/null 2>&1 && curl -sL "$agsbxurl" -o "$SCRIPT_PATH") || (command -v wget >/dev/null 2>&1 && wget -qO "$SCRIPT_PATH" "$agsbxurl")
chmod +x "$SCRIPT_PATH"
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
echo "if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' && ! pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then echo '检测到系统可能中断过，或者变量格式错误？建议在SSH对话框输入 reboot 重启下服务器。现在自动执行Argosbx脚本的节点恢复操作，请稍等……'; sleep 6; export cdnym=\"${cdnym}\" name=\"${name}\" ippz=\"${ippz}\" argo=\"${argo}\" uuid=\"${uuid}\" exvl=\"${exit_vless}\" exvm=\"${exit_vmess}\" exhy2=\"${exit_hy2}\" vmws=\"${vmws_nodes}\" vmwa=\"${vmws_array}\" xwd=\"${exit_warp_domain_suffix}\" xws=\"${exit_warp_rule_set}\" wfd=\"${warp_domain_suffix}\" dfd=\"${direct_domain_suffix}\" wfs=\"${warp_rule_set}\" dfs=\"${direct_rule_set}\" $wap=\"${warp}\" $xhp=\"${port_xh}\" $vxp=\"${port_vx}\" $ssp=\"${port_ss}\" $sop=\"${port_so}\" $anp=\"${port_an}\" $arp=\"${port_ar}\" $vlp=\"${port_vl_re}\" $vwp=\"${port_vw}\" $vmp=\"${port_vm_ws}\" $hyp=\"${port_hy2}\" $tup=\"${port_tu}\" reym=\"${ym_vl_re}\" agn=\"${ARGO_DOMAIN}\" agk=\"${ARGO_AUTH}\"; bash "$HOME/bin/agsbx"; fi" >> ~/.bashrc
fi
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
grep -qxF 'source ~/.bashrc' ~/.bash_profile 2>/dev/null || echo 'source ~/.bashrc' >> ~/.bash_profile
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
sed -i '/agsbx\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsbx\/xray/d' /tmp/crontab.tmp
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsbx/s' || pgrep -f 'agsbx/s' >/dev/null 2>&1 ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsbx/x' || pgrep -f 'agsbx/x' >/dev/null 2>&1 ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/xray run -c $HOME/agsbx/xr.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
fi
sed -i '/agsbx\/cloudflared/d' /tmp/crontab.tmp
if [ -n "$argo" ] && [ -n "$vmag" ]; then
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsbx/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
else
if [ -s "$HOME/agsbx/vmws_ports_multi" ]; then
echo '@reboot sleep 10 && /bin/sh -c "for p in $(cat $HOME/agsbx/vmws_ports_multi 2>/dev/null); do nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:$p --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo-$p.log 2>&1 & done"' >> /tmp/crontab.tmp
else
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &"' >> /tmp/crontab.tmp
fi
fi
fi
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
echo "Argosbx脚本进程启动成功，安装完毕" && sleep 2
else
echo "Argosbx脚本进程未启动，安装失败" && exit
fi
}
argosbxstatus(){
echo "=========当前三大内核运行状态========="
procs=$(find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null)
if echo "$procs" | grep -Eq 'agsbx/s' || pgrep -f 'agsbx/s' >/dev/null 2>&1; then
echo "Sing-box (版本V$("$HOME/agsbx/sing-box" version 2>/dev/null | awk '/version/{print $NF}'))：运行中"
else
echo "Sing-box：未启用"
fi
if echo "$procs" | grep -Eq 'agsbx/x' || pgrep -f 'agsbx/x' >/dev/null 2>&1; then
echo "Xray (版本V$("$HOME/agsbx/xray" version 2>/dev/null | awk '/^Xray/{print $2}'))：运行中"
else
echo "Xray：未启用"
fi
if echo "$procs" | grep -Eq 'agsbx/c' || pgrep -f 'agsbx/c' >/dev/null 2>&1; then
echo "Argo (版本V$("$HOME/agsbx/cloudflared" version 2>/dev/null | awk '{print $3}'))：运行中"
else
echo "Argo：未启用"
fi
}
cip(){
ipbest(){
serip=$( (command -v curl >/dev/null 2>&1 && (curl -s4m5 -k "$v46url" 2>/dev/null || curl -s6m5 -k "$v46url" 2>/dev/null) ) || (command -v wget >/dev/null 2>&1 && (timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null || timeout 3 wget -6 -qO- --tries=2 "$v46url" 2>/dev/null) ) )
if echo "$serip" | grep -q ':'; then
server_ip="[$serip]"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
else
server_ip="$serip"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
}
ipchange(){
v4v6
if [ -z "$v4" ]; then
vps_ipv4='无IPV4'
vps_ipv6="$v6"
location="$v6dq"
elif [ -n "$v4" ] && [ -n "$v6" ]; then
vps_ipv4="$v4"
vps_ipv6="$v6"
location="$v4dq"
else
vps_ipv4="$v4"
vps_ipv6='无IPV6'
location="$v4dq"
fi
if echo "$v6" | grep -q '^2a09'; then
w6="【WARP】"
fi
if echo "$v4" | grep -q '^104.28'; then
w4="【WARP】"
fi
echo
argosbxstatus
echo
echo "=========当前服务器本地IP情况========="
echo "本地IPV4地址：$vps_ipv4 $w4"
echo "本地IPV6地址：$vps_ipv6 $w6"
echo "服务器地区：$location"
echo
sleep 2
if [ "$ippz" = "4" ]; then
if [ -z "$v4" ]; then
ipbest
else
server_ip="$v4"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
elif [ "$ippz" = "6" ]; then
if [ -z "$v6" ]; then
ipbest
else
server_ip="[$v6]"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
else
ipbest
fi
}
ipchange
rm -rf "$HOME/agsbx/jh.txt"
uuid=$(cat "$HOME/agsbx/uuid")
server_ip=$(cat "$HOME/agsbx/server_ip.log")
sxname=$(cat "$HOME/agsbx/name" 2>/dev/null)
xvvmcdnym=$(cat "$HOME/agsbx/cdnym" 2>/dev/null)
echo "*********************************************************"
echo "*********************************************************"
echo "Argosbx脚本输出节点配置如下："
echo
case "$server_ip" in
104.28*|\[2a09*) echo "检测到有WARP的IP作为客户端地址 (104.28或者2a09开头的IP)，请把客户端地址上的WARP的IP手动更换为VPS本地IPV4或者IPV6地址" && sleep 3 ;;
esac
echo
ym_vl_re=$(cat "$HOME/agsbx/ym_vl_re" 2>/dev/null)
cfip() { echo $((RANDOM % 13 + 1)); }
if [ -e "$HOME/agsbx/xray" ]; then
private_key_x=$(cat "$HOME/agsbx/xrk/private_key" 2>/dev/null)
public_key_x=$(cat "$HOME/agsbx/xrk/public_key" 2>/dev/null)
short_id_x=$(cat "$HOME/agsbx/xrk/short_id" 2>/dev/null)
enkey=$(cat "$HOME/agsbx/xrk/enkey" 2>/dev/null)
fi
if [ -e "$HOME/agsbx/sing-box" ]; then
private_key_s=$(cat "$HOME/agsbx/sbk/private_key" 2>/dev/null)
public_key_s=$(cat "$HOME/agsbx/sbk/public_key" 2>/dev/null)
short_id_s=$(cat "$HOME/agsbx/sbk/short_id" 2>/dev/null)
sskey=$(cat "$HOME/agsbx/sskey" 2>/dev/null)
fi
if grep xhttp-reality "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-reality-enc 】支持ENC加密，节点信息如下："
port_xh=$(cat "$HOME/agsbx/port_xh")
vl_xh_link="vless://$uuid@$server_ip:$port_xh?encryption=$enkey&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=xhttp&path=$uuid-xh&mode=auto#${sxname}vl-xhttp-reality-enc-$hostname"
echo "$vl_xh_link" >> "$HOME/agsbx/jh.txt"
echo "$vl_xh_link"
echo
fi
if grep vless-xhttp "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-enc 】支持ENC加密，节点信息如下："
port_vx=$(cat "$HOME/agsbx/port_vx")
vl_vx_link="vless://$uuid@$server_ip:$port_vx?encryption=$enkey&flow=xtls-rprx-vision&type=xhttp&path=$uuid-vx&mode=auto#${sxname}vl-xhttp-enc-$hostname"
echo "$vl_vx_link" >> "$HOME/agsbx/jh.txt"
echo "$vl_vx_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Vless-xhttp-ecn-cdn 】支持ENC加密，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，如是回源端口需手动修改443或者80系端口"
vl_vx_cdn_link="vless://$uuid@yg$(cfip).ygkkk.dpdns.org:$port_vx?encryption=$enkey&flow=xtls-rprx-vision&type=xhttp&host=$xvvmcdnym&path=$uuid-vx&mode=auto#${sxname}vl-xhttp-enc-cdn-$hostname"
echo "$vl_vx_cdn_link" >> "$HOME/agsbx/jh.txt"
echo "$vl_vx_cdn_link"
echo
fi
fi
if grep vless-ws "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-ws-enc 】支持ENC加密，节点信息如下："
port_vw=$(cat "$HOME/agsbx/port_vw")
vl_vw_link="vless://$uuid@$server_ip:$port_vw?encryption=$enkey&flow=xtls-rprx-vision&type=ws&path=$uuid-vw#${sxname}vl-ws-enc-$hostname"
echo "$vl_vw_link" >> "$HOME/agsbx/jh.txt"
echo "$vl_vw_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Vless-ws-enc-cdn 】支持ENC加密，节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，如是回源端口需手动修改443或者80系端口"
vl_vw_cdn_link="vless://$uuid@yg$(cfip).ygkkk.dpdns.org:$port_vw?encryption=$enkey&flow=xtls-rprx-vision&type=ws&host=$xvvmcdnym&path=$uuid-vw#${sxname}vl-ws-enc-cdn-$hostname"
echo "$vl_vw_cdn_link" >> "$HOME/agsbx/jh.txt"
echo "$vl_vw_cdn_link"
echo
fi
fi
if grep reality-vision "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-tcp-reality-vision 】节点信息如下："
port_vl_re=$(cat "$HOME/agsbx/port_vl_re")
vl_link="vless://$uuid@$server_ip:$port_vl_re?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=tcp&headerType=none#${sxname}vl-reality-vision-$hostname"
echo "$vl_link" >> "$HOME/agsbx/jh.txt"
echo "$vl_link"
echo
fi
if grep ss-2022 "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Shadowsocks-2022 】节点信息如下："
port_ss=$(cat "$HOME/agsbx/port_ss")
ss_link="ss://$(echo -n "2022-blake3-aes-128-gcm:$sskey@$server_ip:$port_ss" | base64 -w0)#${sxname}Shadowsocks-2022-$hostname"
echo "$ss_link" >> "$HOME/agsbx/jh.txt"
echo "$ss_link"
echo
fi
if grep vmess-xr "$HOME/agsbx/xr.json" >/dev/null 2>&1 || grep vmess-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
vmess_multi_done=no
if [ -s "$HOME/agsbx/vmws_ports_multi" ]; then
while IFS= read -r node_vm_port; do
[ -n "$node_vm_port" ] || continue
case "$node_vm_port" in *[!0-9]*) continue ;; esac
vm_path="/$uuid-vm-$node_vm_port"
vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-$hostname-$node_vm_port\", \"add\": \"$server_ip\", \"port\": \"$node_vm_port\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"www.bing.com\", \"path\": \"$vm_path\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_link" >> "$HOME/agsbx/jh.txt"
echo "$vm_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
vm_cdn_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-cdn-$hostname-$node_vm_port\", \"add\": \"yg$(cfip).ygkkk.dpdns.org\", \"port\": \"$node_vm_port\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$xvvmcdnym\", \"path\": \"$vm_path\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_cdn_link" >> "$HOME/agsbx/jh.txt"
echo "$vm_cdn_link"
echo
fi
done < "$HOME/agsbx/vmws_ports_multi"
vmess_multi_done=yes
fi
echo "💣【 Vmess-ws 】节点信息如下："
if [ "$vmess_multi_done" = no ]; then
port_vm_ws=$(cat "$HOME/agsbx/port_vm_ws")
vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-$hostname\", \"add\": \"$server_ip\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"www.bing.com\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_link" >> "$HOME/agsbx/jh.txt"
echo "$vm_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Vmess-ws-cdn 】节点信息如下："
echo "注：默认地址 yg数字.ygkkk.dpdns.org 可自行更换优选IP域名，如是回源端口需手动修改443或者80系端口"
vm_cdn_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-cdn-$hostname\", \"add\": \"yg$(cfip).ygkkk.dpdns.org\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$xvvmcdnym\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_cdn_link" >> "$HOME/agsbx/jh.txt"
echo "$vm_cdn_link"
echo
fi
fi
fi
if grep anytls-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 AnyTLS 】节点信息如下："
port_an=$(cat "$HOME/agsbx/port_an")
an_link="anytls://$uuid@$server_ip:$port_an?insecure=1&allowInsecure=1#${sxname}anytls-$hostname"
echo "$an_link" >> "$HOME/agsbx/jh.txt"
echo "$an_link"
echo
fi
if grep anyreality-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Any-Reality 】节点信息如下："
port_ar=$(cat "$HOME/agsbx/port_ar")
ar_link="anytls://$uuid@$server_ip:$port_ar?security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_s&sid=$short_id_s&type=tcp&headerType=none#${sxname}any-reality-$hostname"
echo "$ar_link" >> "$HOME/agsbx/jh.txt"
echo "$ar_link"
echo
fi
if grep hy2-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Hysteria2 】节点信息如下："
port_hy2=$(cat "$HOME/agsbx/port_hy2")
hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=1&sni=www.bing.com#${sxname}hy2-$hostname"
echo "$hy2_link" >> "$HOME/agsbx/jh.txt"
echo "$hy2_link"
echo
fi
if grep tuic5-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Tuic 】节点信息如下："
port_tu=$(cat "$HOME/agsbx/port_tu")
tuic5_link="tuic://$uuid:$uuid@$server_ip:$port_tu?congestion_control=bbr&udp_relay_mode=native&alpn=h3&sni=www.bing.com&allow_insecure=1&allowInsecure=1#${sxname}tuic-$hostname"
echo "$tuic5_link" >> "$HOME/agsbx/jh.txt"
echo "$tuic5_link"
echo
fi
if grep socks5-xr "$HOME/agsbx/xr.json" >/dev/null 2>&1 || grep socks5-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Socks5 】客户端信息如下："
port_so=$(cat "$HOME/agsbx/port_so")
echo "请配合其他应用内置代理使用，勿做节点直接使用"
echo "客户端地址：$server_ip"
echo "客户端端口：$port_so"
echo "客户端用户名：$uuid"
echo "客户端密码：$uuid"
echo
fi
argodomain=$(cat "$HOME/agsbx/sbargoym.log" 2>/dev/null)
[ -z "$argodomain" ] && [ -s "$HOME/agsbx/argo_vmws_map.log" ] && argodomain=$(awk -F'|' 'NR==1{print $2}' "$HOME/agsbx/argo_vmws_map.log" 2>/dev/null)
[ -z "$argodomain" ] && argodomain=$(grep -a trycloudflare.com "$HOME/agsbx/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
if [ -n "$argodomain" ]; then
argo_multi_show=""
vlvm=$(cat $HOME/agsbx/vlvm 2>/dev/null)
if [ "$vlvm" = "Vmess" ]; then
if [ -s "$HOME/agsbx/argo_vmws_map.log" ]; then
argo_multi_idx=0
while IFS='|' read -r map_port map_domain; do
[ -n "$map_port" ] || continue
[ -n "$map_domain" ] || continue
case "$map_port" in *[!0-9]*) continue ;; esac
map_path="/$uuid-vm-$map_port"
if [ "$argo_multi_idx" -eq 0 ]; then
argodomain="$map_domain"
fi
vmatls_tmp="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-$map_port-443\", \"add\": \"yg1.ygkkk.dpdns.org\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$map_domain\", \"path\": \"$map_path\", \"tls\": \"tls\", \"sni\": \"$map_domain\", \"alpn\": \"\", \"fp\": \"chrome\"}" | base64 -w0)"
vma_tmp="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-$map_port-80\", \"add\": \"yg6.ygkkk.dpdns.org\", \"port\": \"80\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$map_domain\", \"path\": \"$map_path\", \"tls\": \"\"}" | base64 -w0)"
if [ "$argo_multi_idx" -eq 0 ]; then
vmatls_link1="$vmatls_tmp"
vma_link7="$vma_tmp"
fi
echo "$vmatls_tmp" >> "$HOME/agsbx/jh.txt"
echo "$vma_tmp" >> "$HOME/agsbx/jh.txt"
argo_multi_show="${argo_multi_show}${map_port} -> ${map_domain}
"
argo_multi_idx=$((argo_multi_idx + 1))
done < "$HOME/agsbx/argo_vmws_map.log"
else
vmatls_link1="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-443\", \"add\": \"yg1.ygkkk.dpdns.org\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vmatls_link1" >> "$HOME/agsbx/jh.txt"
vmatls_link2="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-8443\", \"add\": \"yg2.ygkkk.dpdns.org\", \"port\": \"8443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vmatls_link2" >> "$HOME/agsbx/jh.txt"
vmatls_link3="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2053\", \"add\": \"yg3.ygkkk.dpdns.org\", \"port\": \"2053\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vmatls_link3" >> "$HOME/agsbx/jh.txt"
vmatls_link4="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2083\", \"add\": \"yg4.ygkkk.dpdns.org\", \"port\": \"2083\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vmatls_link4" >> "$HOME/agsbx/jh.txt"
vmatls_link5="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2087\", \"add\": \"yg5.ygkkk.dpdns.org\", \"port\": \"2087\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vmatls_link5" >> "$HOME/agsbx/jh.txt"
vmatls_link6="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2096\", \"add\": \"[2606:4700::0]\", \"port\": \"2096\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$vmatls_link6" >> "$HOME/agsbx/jh.txt"
vma_link7="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-80\", \"add\": \"yg6.ygkkk.dpdns.org\", \"port\": \"80\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link7" >> "$HOME/agsbx/jh.txt"
vma_link8="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-8080\", \"add\": \"yg7.ygkkk.dpdns.org\", \"port\": \"8080\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link8" >> "$HOME/agsbx/jh.txt"
vma_link9="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-8880\", \"add\": \"yg8.ygkkk.dpdns.org\", \"port\": \"8880\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link9" >> "$HOME/agsbx/jh.txt"
vma_link10="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2052\", \"add\": \"yg9.ygkkk.dpdns.org\", \"port\": \"2052\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link10" >> "$HOME/agsbx/jh.txt"
vma_link11="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2082\", \"add\": \"yg10.ygkkk.dpdns.org\", \"port\": \"2082\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link11" >> "$HOME/agsbx/jh.txt"
vma_link12="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2086\", \"add\": \"yg11.ygkkk.dpdns.org\", \"port\": \"2086\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link12" >> "$HOME/agsbx/jh.txt"
vma_link13="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2095\", \"add\": \"[2400:cb00:2049::0]\", \"port\": \"2095\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link13" >> "$HOME/agsbx/jh.txt"
fi
elif [ "$vlvm" = "Vless" ]; then
vwatls_link1="vless://$uuid@yg$(cfip).ygkkk.dpdns.org:443?encryption=$enkey&flow=xtls-rprx-vision&type=ws&host=$argodomain&path=$uuid-vw&security=tls&sni=$argodomain&fp=chrome&insecure=0&allowInsecure=0#${sxname}vless-ws-tls-argo-enc-vision-$hostname"
echo "$vwatls_link1" >> "$HOME/agsbx/jh.txt"
vwa_link2="vless://$uuid@yg$(cfip).ygkkk.dpdns.org:80?encryption=$enkey&flow=xtls-rprx-vision&type=ws&host=$argodomain&path=$uuid-vw&security=none#${sxname}vless-ws-argo-enc-vision-$hostname"
echo "$vwa_link2" >> "$HOME/agsbx/jh.txt"
fi
sbtk=$(cat "$HOME/agsbx/sbargotoken.log" 2>/dev/null)
if [ -n "$sbtk" ]; then
nametn="Argo固定隧道token：$sbtk"
fi
argoshow=$(
echo "Argo隧道端口正在使用$vlvm-ws主协议端口：$(cat $HOME/agsbx/argoport.log 2>/dev/null)
Argo域名：$argodomain
$nametn
$argo_multi_show

1、💣443端口的$vlvm-ws-tls-argo节点(优选IP与443系端口随便换)
${vmatls_link1}${vwatls_link1}

2、💣80端口的$vlvm-ws-argo节点(优选IP与80系端口随便换)
${vma_link7}${vwa_link2}
"
)
fi
echo "---------------------------------------------------------"
echo "$argoshow"
echo
echo "---------------------------------------------------------"
echo "聚合节点信息，请进入 $HOME/agsbx/jh.txt 文件目录查看或者运行 cat $HOME/agsbx/jh.txt 查看"
echo "========================================================="
echo "相关快捷方式如下：(首次安装成功后需重连SSH，agsbx快捷方式才可生效)"
showmode
}
cleandel(){
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsbx/c|/agsbx/s|/agsbx/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null; fi; fi; done
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) $(pgrep -f 'agsbx/c' 2>/dev/null) $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
sed -i '/agsbx/d' ~/.bashrc
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/agsbx\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsbx\/xray/d' /tmp/crontab.tmp
sed -i '/agsbx\/cloudflared/d' /tmp/crontab.tmp
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
rm -rf  "$HOME/bin/agsbx"
if pidof systemd >/dev/null 2>&1; then
for svc in xr sb argo; do
systemctl stop "$svc" >/dev/null 2>&1
systemctl disable "$svc" >/dev/null 2>&1
done
rm -rf /etc/systemd/system/{xr.service,sb.service,argo.service}
elif command -v rc-service >/dev/null 2>&1; then
for svc in sing-box xray argo; do
rc-service "$svc" stop >/dev/null 2>&1
rc-update del "$svc" default >/dev/null 2>&1
done
rm -rf /etc/init.d/{sing-box,xray,argo}
fi
}
xrestart(){
kill -15 $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
ensure_xray_geo_data
if pidof systemd >/dev/null 2>&1; then
systemctl restart xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service xray restart >/dev/null 2>&1
else
nohup $HOME/agsbx/xray run -c $HOME/agsbx/xr.json >/dev/null 2>&1 &
fi
}
sbrestart(){
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) >/dev/null 2>&1
if pidof systemd >/dev/null 2>&1; then
systemctl restart sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service sing-box restart >/dev/null 2>&1
else
nohup $HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json >/dev/null 2>&1 &
fi
}

if [ "$1" = "del" ]; then
cleandel
rm -rf "$HOME/agsbx" "$HOME/agsb"
echo "卸载完成"
echo "欢迎继续使用甬哥侃侃侃ygkkk的Argosbx一键无交互小钢炮脚本💣" && sleep 2
echo
showmode
exit
elif [ "$1" = "rep" ]; then
cleandel
rm -rf "$HOME/agsbx"/{sb.json,xr.json,sbargoym.log,sbargotoken.log,argo.log,argoport.log,argo_vmws_map.log,vmws_ports_multi,vmws_nodes,vmws_array,cdnym,name}
rm -rf "$HOME/agsbx/vmws_nodes.d"
echo "Argosbx重置协议完成，开始更新相关协议变量……" && sleep 2
echo
elif [ "$1" = "list" ]; then
cip
exit
elif [ "$1" = "upx" ]; then
for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in *"/agsbx/x"*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
kill -15 $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
upxray && xrestart && echo "Xray内核更新完成" && sleep 2 && cip
exit
elif [ "$1" = "ups" ]; then
for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in *"/agsbx/s"*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) >/dev/null 2>&1
upsingbox && sbrestart && echo "Sing-box内核更新完成" && sleep 2 && cip
exit
elif [ "$1" = "res" ]; then
for P in /proc/[0-9]*; do
[ -L "$P/exe" ] || continue
TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue
case "$TARGET" in
*"/agsbx/s"*)
kill "$(basename "$P")" 2>/dev/null
sbrestart
;;
*"/agsbx/x"*)
kill "$(basename "$P")" 2>/dev/null
xrestart
;;
*"/agsbx/c"*)
kill "$(basename "$P")" 2>/dev/null
kill -15 $(pgrep -f 'agsbx/c' 2>/dev/null) >/dev/null 2>&1
if pidof systemd >/dev/null 2>&1; then
systemctl restart argo >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service argo restart >/dev/null 2>&1
else
if [ -e "$HOME/agsbx/sbargotoken.log" ]; then
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
nohup $HOME/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsbx/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &
fi
else
if [ -s "$HOME/agsbx/vmws_ports_multi" ]; then
start_multi_vmws_argo_temp
else
nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log 2>/dev/null) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &
fi
fi
fi
;;
esac
done
sleep 5 && echo "重启完成" && sleep 3 && cip
exit
fi
if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' && ! pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsbx/c|/agsbx/s|/agsbx/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null && echo "Killed $PID ($TARGET)" || echo "Could not kill $PID ($TARGET)"; fi; fi; done
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) $(pgrep -f 'agsbx/c' 2>/dev/null) $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
if [ -z "$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null) )" ]; then
echo -e "nameserver 2a00:1098:2b::1\nnameserver 2a00:1098:2c::1" > /etc/resolv.conf
fi
if [ -n "$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 -qO- --tries=2 "$v46url" 2>/dev/null) )" ]; then
sendip="2606:4700:d0::a29f:c001"
xendip="[2606:4700:d0::a29f:c001]"
else
sendip="162.159.192.1"
xendip="162.159.192.1"
fi
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "Argosbx脚本未安装，开始安装…………" && sleep 1
if [ -n "$oap" ]; then
setenforce 0 >/dev/null 2>&1
iptables -P INPUT ACCEPT >/dev/null 2>&1
iptables -P FORWARD ACCEPT >/dev/null 2>&1
iptables -P OUTPUT ACCEPT >/dev/null 2>&1
iptables -F >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
echo
echo "iptables执行开放所有端口"
fi
ins
cip
echo
else
echo "Argosbx脚本已安装"
echo
argosbxstatus
echo
echo "相关快捷方式如下："
showmode
exit
fi
