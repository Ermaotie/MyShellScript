#! /bin/bash
echo "静态IP设置"
echo "---------------------"
read -p "请输入静态IP" static_ip

sudo su -<<EOEO
cat >> "/etc/dhcpcd.conf" << EOF
interface wlan0
# 指定静态IP，/24表示子网掩码为 255.255.255.0
static ip_address=${static_ip}/24
# 路由器/网关IP地址
static routers=192.168.1.1

EOF
echo "静态IP设置完成！"

echo "更换软件源"
echo "---------------------"
echo "正在更换更换清华源"

cat > "/etc/apt/sources.list" <<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main non-free contrib rpi
deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main non-free contrib rpi
EOF

cat > "/etc/apt/sources.list.d/raspi.list" <<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ stretch main ui
EOF

apt update

echo "换源完成!"

# eheh 监控
echo "部署eheh监控"
wget -N --no-check-certificate https://eheh.org/shell/install.sh && bash install.sh db3b6a9bcd0e85e9bc30e64ec067085f
EOEO


# FRP
bash "./pi_frp.sh"
# 网易云音乐
bash "./pi_neteaseMusicUnblock"
# scut 通知
bash "./pi_scut_notice"
echo "请自行添加crontab"

reboot