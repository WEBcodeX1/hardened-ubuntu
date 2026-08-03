#!/bin/sh

ISO_FILE="ubuntu-26.04-desktop-amd64.iso"

# copy eltorito image for hybrid iso (non-efi part)
mkdir -p /boot/grub/i386-pc
cp -Ra /usr/lib/grub/i386-pc/eltorito.img /boot/grub/i386-pc/eltorito.img

# extract Ubuntu ISO
mkdir -p /tmp/ubuntu-iso /tmp/ubuntu-custom
mount -o loop "${ISO_FILE}" /tmp/ubuntu-iso
cp -rT /tmp/ubuntu-iso /tmp/ubuntu-custom

# add autoinstall configuration
mkdir -p /tmp/ubuntu-custom/autoinstall
cp ../autoinstall/autoinstall.yaml /tmp/ubuntu-custom/

# copy hardening scripts to ISO
mkdir -p /tmp/ubuntu-custom/hardening
cp ../*.sh ../*.conf ../*.toml ../*.yaml ../*.js ../*.service ../*.tpl ../*.desktop ../hosts ../debconf-selections.txt /tmp/ubuntu-custom/hardening/

# add grub autoinstall entry
sed -i "7r ../autoinstall/grub-autoinstall-entry.cfg" /tmp/ubuntu-custom/boot/grub/grub.cfg

# Read EFI partition offsets directly from the ISO's MBR partition table.
# EFI_START_D / EFI_END_D  -> xorriso --interval:local_fs 'd' (512-byte disk sector) suffix
# EFI_SIZE_D               -> xorriso -boot-load-size and size_Xd (512-byte disk sectors)
# EFI_START_S              -> xorriso appended_partition_2_start 's' (2048-byte ISO sector) suffix
EFI_PARAMS=$(python3 "$(dirname "$0")/get_efi_params.py" "${ISO_FILE}")
EFI_START_D=$(echo "${EFI_PARAMS}" | cut -d' ' -f1)
EFI_SIZE_D=$(echo "${EFI_PARAMS}" | cut -d' ' -f2)
EFI_END_D=$(( EFI_START_D + EFI_SIZE_D - 1 ))
EFI_START_S=$(( EFI_START_D / 4 ))

# create custom (hybrid) ISO
xorriso \
  -as mkisofs \
  -V "Ubuntu 26.04 LTS Hardened" \
  --modification-date="$(date -u +"%Y%m%d%H%M%S00")" \
  --grub2-mbr --interval:local_fs:0s-15s:zero_mbrpt,zero_gpt:"${ISO_FILE}" \
  --protective-msdos-label \
  -partition_cyl_align off \
  -partition_offset 16 \
  --mbr-force-bootable \
  -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b --interval:local_fs:"${EFI_START_D}d-${EFI_END_D}d"::"${ISO_FILE}" \
  -appended_part_as_gpt \
  -iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 \
  -c '/boot.catalog' \
  -b '/boot/grub/i386-pc/eltorito.img' \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  --grub2-boot-info \
  -eltorito-alt-boot \
  -e "--interval:appended_partition_2_start_${EFI_START_S}s_size_${EFI_SIZE_D}d:all::" \
  -no-emul-boot \
  -boot-load-size "${EFI_SIZE_D}" \
  -o ubuntu-26.04-hardened.iso \
  /tmp/ubuntu-custom/
