# 1) 校内服务器启动 iperf3 服务（建议固定端口 5201）
iperf3 -s -p 5201

# 2) Termux 测 TCP 上行（手机 -> 校内服务器）
iperf3 -c 39.106.154.49 -p 5201 -t 20 -i 1 -P 4

# 3) Termux 测 TCP 下行（校内服务器 -> 手机）
iperf3 -c 39.106.154.49 -p 5201 -t 20 -i 1 -P 4 -R

# 4) Termux 测 UDP 上行（看带宽/丢包/抖动）
iperf3 -c 39.106.154.49 -p 5201 -u -b 30M -t 20 -i 1

# 5) Termux 测 UDP 下行（反向）
iperf3 -c 39.106.154.49 -p 5201 -u -b 30M -t 20 -i 1 -R

# 6) 如果要保存 JSON 结果
iperf3 -c 39.106.154.49 -p 5201 -t 20 -i 1 -P 4 --json > tcp_up.json

iperf3 -c 39.106.154.49 -p 7000 -u -b 30M -t 20 -i 1
iperf3 -c 39.106.154.49 -p 7000 -u -b 30M -t 20 -i 1 -R

# 客户端：明确用iperf3连7000（别混入别的命令）
iperf3 -c 39.106.154.49 -p 7000 -u -b 30M -t 20 -i 1

