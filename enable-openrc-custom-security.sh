#!/bin/sh

# get env vars
net_if_name="${NET_IF_NAME}"

# copy custom security script
cp ./set-custom-security.sh /usr/local/bin/

# replace correct interface name
sed -i "s/\[NET_IF_NAME\]/${net_if_name}/g" /usr/local/bin/set-custom-security.sh

# set permissions
chown root:root /usr/local/bin/set-custom-security.sh
chmod 500 /usr/local/bin/set-custom-security.sh

# install OpenRC service or SysV init script depending on init system
if command -v rc-update >/dev/null 2>&1; then
    # OpenRC: install openrc-run script
    cp ./openrc-custom-security /etc/init.d/custom-security
    chown root:root /etc/init.d/custom-security
    chmod 755 /etc/init.d/custom-security
    rc-update add custom-security default
else
    # SysV-style init: install LSB init script and create /etc/rcX.d symlinks
    cp ./rc-custom-security.sh /etc/init.d/custom-security
    chown root:root /etc/init.d/custom-security
    chmod 755 /etc/init.d/custom-security
    for runlevel in 2 3 4 5; do
        ln -sf /etc/init.d/custom-security "/etc/rc${runlevel}.d/S99custom-security"
    done
    for runlevel in 0 1 6; do
        ln -sf /etc/init.d/custom-security "/etc/rc${runlevel}.d/K01custom-security"
    done
fi
