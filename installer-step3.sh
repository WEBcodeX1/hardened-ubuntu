#!/bin/sh

# export config to current env
. ./config.sh

# install packages
. ./apt-install-cmds.sh

# install firefox
. ./install-non-snapd-firefox.sh

# remove snapd desktop apps / icons
rm /var/lib/snapd/desktop/applications/*

# set custom security (service)
. ./enable-systemd-custom-security.sh

