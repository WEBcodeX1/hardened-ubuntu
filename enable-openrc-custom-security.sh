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

# copy SysV init script to /etc/init.d
cp ./rc-custom-security.sh /etc/init.d/custom-security
chown root:root /etc/init.d/custom-security
chmod 755 /etc/init.d/custom-security

# copy OpenRC service script to /etc/init.d (preferred when OpenRC is present)
if command -v rc-update >/dev/null 2>&1; then
    cp ./openrc-custom-security /etc/init.d/custom-security
    chown root:root /etc/init.d/custom-security
    chmod 755 /etc/init.d/custom-security
    rc-update add custom-security default
else
    # create /etc/rcX.d symlinks for SysV-style init
    for runlevel in 2 3 4 5; do
        ln -sf /etc/init.d/custom-security "/etc/rc${runlevel}.d/S99custom-security"
    done
    for runlevel in 0 1 6; do
        ln -sf /etc/init.d/custom-security "/etc/rc${runlevel}.d/K01custom-security"
    done
fi
