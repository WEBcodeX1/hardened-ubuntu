#!/bin/sh

# copy module blacklist config
cp ./modules-blacklist.conf /etc/modprobe.d/blacklist-misc.conf

# update ramdisk
update-initramfs -u
