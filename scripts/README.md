# Instructions

On a *Ubuntu 25.10* installation, do the following:

## Dependencies

```bash
apt-get install xorriso grub-pc-bin
```

## Run ISO Generation Script

```bash
cd ./iso && sudo ../scripts/mkiso.sh
```

> [!NOTE]
> The `mkiso.sh` script depends on `eltorito.img` for making a hybrid ISO (also non-efi bootable)
> which is **not** included in a debian system, only on Ubuntu.

> [!NOTE]
> The `mkiso.sh` must be run as root (`sudo` or directly) from the parent (`../`) path.
