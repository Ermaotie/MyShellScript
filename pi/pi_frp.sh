#! /bin/bash
# frp
frp_path=${HOME}"/frp"
if [ ! -d ${frp_path} ]; then
  mkdir ${frp_path}
  echo "使用freefrp.net服务"
  echo "安装FRP"
  wget https://ghproxy.com/https://github.com/fatedier/frp/releases/download/v0.38.0/frp_0.38.0_linux_arm.tar.gz
  tar -xvf frp_*.tar.gz
  mv frp_*/* ${frp_path}
  rmdir frp_*arm
  rm frp_*.tar.gz
fi

echo "随机ssh对应外部端口"

# 区间随机数
function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(($RANDOM+1000000000)) #增加一个10位的数再求余
    echo $(($num%$max+$min))
}

server_addr="frp2.freefrp.net"
server_port="7000"
remote_port=$(rand 10001 50000)
token="freefrp.net"
config_path=${frp_path}"/frpc.ini"
static_ip="192.168.1.121"

cat > ${config_path}<<EOF
[common]
server_addr = ${server_addr}
server_port = ${server_port}
token = $token
[pi_ssh]
type=tcp
local_ip= ${static_ip}
local_port=22
remote_port=$remote_port
EOF

echo "SSH链接为："
echo ${server_addr}:${remote_port}


service_path="/usr/lib/systemd/system/frpc.service"
sudo su -<<EOEO
cat > ${service_path}<<EOF
[Unit]
Description=Frpc
After=network.target

[Service]
Type=simple
ExecStart=${frp_path}/frpc -c ${frp_path}/frpc.ini
Restart=on-failure
RestartSec=5s
WorkingDirectory=${frp_path}

[Install]
WantedBy=multi-user.target
EOF
EOEO

sudo systemctl start frpc.service
sudo systemctl enable frpc.service

echo "开启开机自启FRPc"