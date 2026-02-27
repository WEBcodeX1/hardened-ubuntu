#!/bin/sh

# get env vars
grub_kernel_cmdline=`printenv GRUB_KERNEL_CMDLINE`

# disable ipv6, set kernel commandline from config
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash ipv6.disable=1 ${grub_kernel_cmdline}"/g' /etc/default/grub

# disable crashkernel
echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT crashkernel=no"' > /etc/default/grub.d/kdump-tools.cfg

# update grub (write to mbr)
update-grub
