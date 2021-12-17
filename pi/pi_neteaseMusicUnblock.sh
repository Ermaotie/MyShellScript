#! /bin/bash
# NeteaseMusicBlock
music_path=${HOME}"/neteaseMusicUnblock"
version_origin=$(node --version | sed 's/^v//')
version_need="16.0.0"
function version_le() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }
if version_le $version_need $version_origin; then
  bash ./pi_update_node.sh
fi

if [ ! -d ${music_path} ]; then
  mkdir ${music_path}
fi

rm -rf ${music_path}/server
cd ${music_path}
echo "使用网易云音乐解锁服务"
echo "安装音乐解锁"
export GIT_SSL_NO_VERIFY=1
git clone https://ghproxy.com/https://github.com/UnblockNeteaseMusic/server.git
cd server
npm --registry https://registry.npm.taobao.org install @unblockneteasemusic/server

service_path="/usr/lib/systemd/system/unblock.service"
sudo su -<<EOEO
cat > ${service_path}<<EOF
[Unit]
Description=unblock
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/node ${music_path}/server/app.js
Restart=on-failure
RestartSec=5s
WorkingDirectory=${music_path}/server

[Install]
WantedBy=multi-user.target
EOF
EOEO

sudo systemctl start unblock.service
sudo systemctl enable unblock.service

echo "开启开机自启 UnblockNeteaseMusic"