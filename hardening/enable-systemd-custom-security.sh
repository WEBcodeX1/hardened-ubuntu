#!/bin/sh

# get env vars
net_if_name=`printenv NET_IF_NAME`

# copy custom security script
cp ./set-custom-security.sh /usr/local/bin/

# replace correct interface name
sed -i "s/\[NET_IF_NAME\]/${net_if_name}/g" /usr/local/bin/set-custom-security.sh

# set permissions
chown root:root /usr/local/bin/set-custom-security.sh
chmod 500 /usr/local/bin/set-custom-security.sh

# copy service script to systemd
cp ./systemd-custom-security.service /etc/systemd/system/custom-security.service

# enable service
systemctl enable custom-security
