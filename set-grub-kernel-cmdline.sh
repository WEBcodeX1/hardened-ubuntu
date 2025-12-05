#!/bin/sh

# disable ipv6, set iommu strict mode
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash ipv6.disable=1 intel_iommu=igfx_off iommu.strict=1"/g' /etc/default/grub

# disable crashkernel
echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT crashkernel=no"' > /etc/default/grub.d/kdump-tools.cfg

# update grub (write to mbr)
update-grub
