# Grub Remarks (Autoinstall ISO)

On the autoinstall iso (usb-stick) **one** autoinstall grub entry with modified kernel command line
must be **added** so autoinstall will be triggered automatically.

## 1. Default Grub Config

The following config is the default config located under `/boot/grub/grub.cfg`.

```bash
set timeout=30

loadfont unicode

set menu_color_normal=white/black
set menu_color_highlight=black/light-gray

menuentry "Try or Install Ubuntu" {
	set gfxpayload=keep
	linux	/casper/vmlinuz --- quiet splash
	initrd	/casper/initrd
}
menuentry "Ubuntu (safe graphics)" {
	set gfxpayload=keep
	linux	/casper/vmlinuz nomodeset  --- quiet splash
	initrd	/casper/initrd
}
grub_platform
if [ "$grub_platform" = "efi" ]; then
menuentry 'Boot from next volume' {
	exit 1
}
menuentry 'UEFI Firmware Settings' {
	fwsetup
}
else
menuentry 'Test memory' {
	linux16 /boot/memtest86+x64.bin
}
fi
```

## 2. Modify Grub Config

Add the following menuentry **before** the first one (it will be booted automatically after
the timeout has been reached).

```bash
menuentry "Ubuntu Autoinstall" {
	set gfxpayload=keep
	linux	/casper/vmlinuz autoinstall ds=nocloud --- quiet splash
	initrd	/casper/initrd
}
```

## 3. Complete Config

```bash
set timeout=30

loadfont unicode

set menu_color_normal=white/black
set menu_color_highlight=black/light-gray

menuentry "Ubuntu Autoinstall" {
	set gfxpayload=keep
	linux	/casper/vmlinuz autoinstall ds=nocloud --- quiet splash
	initrd	/casper/initrd
}
menuentry "Try or Install Ubuntu" {
	set gfxpayload=keep
	linux	/casper/vmlinuz --- quiet splash
	initrd	/casper/initrd
}
menuentry "Ubuntu (safe graphics)" {
	set gfxpayload=keep
	linux	/casper/vmlinuz nomodeset  --- quiet splash
	initrd	/casper/initrd
}
grub_platform
if [ "$grub_platform" = "efi" ]; then
menuentry 'Boot from next volume' {
	exit 1
}
menuentry 'UEFI Firmware Settings' {
	fwsetup
}
else
menuentry 'Test memory' {
	linux16 /boot/memtest86+x64.bin
}
fi
```
