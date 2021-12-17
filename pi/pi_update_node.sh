#! /bin/bash
# Update Node

sudo apt-get remove nodejs -y
sudo apt-get purge nodejs -y
sudo rm /usr/bin/node
sudo rm /usr/bin/npm

source_url="https://nodejs.org/dist/v16.13.1/node-v16.13.1-linux-armv7l.tar.xz"

wget $source_url
tar -xvf node-*.tar.xz
sudo mv ./node-*-armv7l /usr/local/node
sudo ln -s /usr/local/node/bin/node /usr/bin/node
sudo ln -s /usr/local/node/bin/npm /usr/bin/npm
echo $(node --version)
rm node-*.tar.xz