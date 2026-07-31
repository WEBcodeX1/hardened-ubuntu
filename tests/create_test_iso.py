#!/usr/bin/env python3
"""Create minimal mock ISO files for use in mkiso tests.

Two layout modes are supported:

  mbr   - 512-byte MBR-only ISO with an EFI System Partition entry (type 0xEF)
  gpt   - 34-LBA ISO with a Protective MBR and a GPT containing an EFI System
           Partition entry (GUID C12A7328-F81F-11D2-BA4B-00A0C93EC93B).  This
           matches the layout used by Ubuntu 26.04 ISOs.

Usage:
    create_test_iso.py <output_file> <layout> <lba_start> <lba_size>

    <layout>  mbr | gpt
"""

import struct
import sys

# EFI System Partition type GUID (mixed-endian, as stored on disk)
EFI_SYSTEM_PARTITION_GUID = bytes([
    0x28, 0x73, 0x2A, 0xC1,
    0x1F, 0xF8,
    0xD2, 0x11,
    0xBA, 0x4B,
    0x00, 0xA0, 0xC9, 0x3E, 0xC9, 0x3B,
])


def create_mbr_iso(output_file, lba_start, lba_size):
    """512-byte ISO with a single MBR partition entry of type 0xEF."""
    buf = bytearray(512)
    buf[510] = 0x55
    buf[511] = 0xAA
    entry = bytearray(16)
    entry[4] = 0xEF
    struct.pack_into("<I", entry, 8, lba_start)
    struct.pack_into("<I", entry, 12, lba_size)
    buf[446:462] = entry
    with open(output_file, "wb") as f:
        f.write(buf)


def create_gpt_iso(output_file, lba_start, lba_size):
    """34-LBA ISO with a Protective MBR and a GPT EFI System Partition entry."""
    buf = bytearray(512 * 34)

    # LBA 0: Protective MBR — single 0xEE entry, no 0xEF entry
    buf[446 + 4] = 0xEE
    struct.pack_into("<I", buf, 446 + 8, 1)
    struct.pack_into("<I", buf, 446 + 12, 0xFFFFFFFF)
    buf[510] = 0x55
    buf[511] = 0xAA

    # LBA 1: GPT header
    lba_end = lba_start + lba_size - 1
    hdr = bytearray(512)
    hdr[0:8] = b"EFI PART"
    hdr[8:12] = b"\x00\x00\x01\x00"   # revision 1.0
    struct.pack_into("<I", hdr, 12, 92)             # header size
    struct.pack_into("<I", hdr, 16, 0)              # CRC32 (omitted in test)
    struct.pack_into("<Q", hdr, 24, 1)              # current LBA
    struct.pack_into("<Q", hdr, 32, 33)             # backup LBA
    struct.pack_into("<Q", hdr, 40, 34)             # first usable LBA
    struct.pack_into("<Q", hdr, 48, lba_end + 1)    # last usable LBA
    hdr[56:72] = b"\xAB" * 16                       # disk GUID (arbitrary)
    struct.pack_into("<Q", hdr, 72, 2)              # partition entries LBA
    struct.pack_into("<I", hdr, 80, 128)            # number of entries
    struct.pack_into("<I", hdr, 84, 128)            # size of each entry
    buf[512:1024] = hdr

    # LBA 2: first GPT partition entry — EFI System Partition
    entry = bytearray(128)
    entry[0:16] = EFI_SYSTEM_PARTITION_GUID
    entry[16:32] = b"\xCD" * 16                    # unique GUID (arbitrary)
    struct.pack_into("<Q", entry, 32, lba_start)
    struct.pack_into("<Q", entry, 40, lba_end)
    buf[1024:1152] = entry

    with open(output_file, "wb") as f:
        f.write(buf)


if __name__ == "__main__":
    if len(sys.argv) != 5 or sys.argv[2] not in ("mbr", "gpt"):
        print(
            f"Usage: {sys.argv[0]} <output_file> <mbr|gpt> <lba_start> <lba_size>",
            file=sys.stderr,
        )
        sys.exit(1)

    _, output_file, layout, raw_start, raw_size = sys.argv
    start = int(raw_start)
    size = int(raw_size)

    if layout == "mbr":
        create_mbr_iso(output_file, start, size)
    else:
        create_gpt_iso(output_file, start, size)
