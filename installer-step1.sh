#!/bin/sh

# export config to current env
. ./config.sh

# patch http(s) mirrors
. ./patch-ubuntu-mirrors-https.sh

# set static nextdns addresses
. ./patch-hosts.sh

# setup netplan
. ./setup-netplan.sh

# remove unwanted apt packages
. ./apt-remove-cmds.sh

# disable services
. ./disable-services.sh
. ./disable-dbus-services.sh

# blacklist modules
. ./modules-blacklist.sh

# set limits
. ./set-limits.sh

# set sysctl config
. ./set-sysctl.sh

# set grub kernel command line
. ./set-grub-kernel-cmdline.sh

