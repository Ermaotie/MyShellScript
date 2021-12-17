#! /bin/bash 
# SCUT 通知

notice_path=${HOME}/scut_notice

# node版本控制
version_origin=$(node --version | sed 's/^v//')
version_need="16.0.0"
function version_le() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }
if version_le $version_need $version_origin; then
  bash ./pi_update_node.sh
fi

if [ ! -d ${notice_path} ]; then
  mkdir ${notice_path}
fi

cd $notice_path
export GIT_SSL_NO_VERIFY=1
git clone https://ghproxy.com/https://github.com/Ermaotie/scutNotice.git
cd scutNotice
npm --registry https://registry.npm.taobao.org install

service_path="/usr/lib/systemd/system/scutNotice.service"
sudo su -<<EOEO
cat > ${service_path}<<EOF
[Unit]
Description=unblock
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/node ${notice_path}/scutNotice/server.js
Restart=on-failure
RestartSec=5s
WorkingDirectory=${notice_path}/scutNotice

[Install]
WantedBy=multi-user.target
EOF
EOEO

sudo systemctl start scutNotice.service
sudo systemctl enable scutNotice.service

echo "开启开机自启 Scut Notice"