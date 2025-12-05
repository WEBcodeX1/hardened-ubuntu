#!/bin/sh

# get env vars
kernel_domain_name=`printenv KERNEL_DOMAIN_NAME`

# copy sysctl config
cp ./sysctl-10-domainname.conf /etc/sysctl.d/10-domainname.conf
cp ./sysctl-10-net.conf /etc/sysctl.d/10-net.conf
cp ./sysctl-20-misc.conf /etc/sysctl.d/20-misc.conf
cp ./sysctl-55-kernel-hardening.conf /etc/sysctl.d/55-kernel-hardening.conf
cp ./sysctl-99-coredump.conf /etc/sysctl.d/99-coredump.conf

# deactivate system wide config
ln -s /dev/null /etc/sysctl.d/10-coredump-debian.conf
ln -s /dev/null /etc/sysctl.d/50-default.conf
ln -s /dev/null /etc/sysctl.d/55-network-security.conf
ln -s /dev/null /etc/sysctl.d/55-ptrace.conf
ln -s /dev/null /etc/sysctl.d/55-magic-sysrq.conf

# replace params
sed -i "s/\[KERNEL_DOMAIN_NAME\]/${kernel_domain_name}/g" /etc/sysctl.d/10-domainname.conf

# update ramdisk
update-initramfs -u
