#!/bin/sh

# export config to env
. ./config.sh

# patch http(s) mirrors
. ./patch-ubuntu-mirrors-https.sh

# set static
. ./patch-ubuntu-mirrors-https.sh

# setup netplan
. ./setup-netplan.sh

# remove unwanted apt packages
. ./apt-remove-cmds.sh

# install usbguard, dnscrypt-proxy, libnss-resolve
. ./apt-preinstall-cmds.sh
