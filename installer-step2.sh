#!/bin/sh

# export config to current env
. ./config.sh

# install usbguard, dnscrypt-proxy, libnss-resolve
. ./apt-preinstall-cmds.sh

# append dns dhcp-override to netplan
cat ./netplan-dns-override-part.yaml >> /etc/netplan/02-net-if-config.yaml
