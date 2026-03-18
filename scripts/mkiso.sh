#!/bin/sh

# extract Ubuntu ISO
mkdir -p /tmp/ubuntu-iso /tmp/ubuntu-custom
mount -o loop iso/ubuntu-25.10-desktop-amd64.iso /tmp/ubuntu-iso
cp -rT /tmp/ubuntu-iso /tmp/ubuntu-custom

# add autoinstall configuration
mkdir -p /tmp/ubuntu-custom/autoinstall
cp autoinstall/autoinstall.yaml /tmp/ubuntu-custom/

# copy hardening scripts to ISO
mkdir -p /tmp/ubuntu-custom/hardening
cp *.sh *.conf *.toml *.yaml *.js /tmp/ubuntu-custom/hardening/

# create custom (hybrid) ISO
xorriso \
  -as mkisofs \
  -V "Ubuntu 25.10 Hardened" \
  --modification-date="$(shell date -u +"%Y%m%d%H%M%S00")" \
  --grub2-mbr --interval:local_fs:0s-15s:zero_mbrpt,zero_gpt:'ubuntu-25.10-desktop-amd64.iso' \
  --protective-msdos-label \
  -partition_cyl_align off \
  -partition_offset 16 \
  --mbr-force-bootable \
  -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b --interval:local_fs:11126816d-11137071d::'ubuntu-25.10-desktop-amd64.iso' \
  -appended_part_as_gpt \
  -iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 \
  -c '/boot.catalog' \
  -b '/boot/grub/i386-pc/eltorito.img' \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  --grub2-boot-info \
  -eltorito-alt-boot \
  -e '--interval:appended_partition_2_start_2781704s_size_10256d:all::' \
  -no-emul-boot \
  -boot-load-size 10256 \
  -o /tmp/ubuntu-25.10-hardened.iso \
  /tmp/ubuntu-custom/
