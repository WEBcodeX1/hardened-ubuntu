#!/usr/bin/env python3
"""Create a minimal mock ISO file for use in mkiso tests.

Writes a 512-byte buffer containing a valid MBR signature and one
EFI System Partition entry (type 0xEF) with the given LBA start and size.

Usage:
    create_test_iso.py <output_file> <lba_start> <lba_size>
"""

import struct
import sys


def create_test_iso(output_file, lba_start, lba_size):
    buf = bytearray(512)

    # MBR signature
    buf[510] = 0x55
    buf[511] = 0xAA

    # Partition entry at offset 446:
    #   byte 0:  status (0x00 = not active)
    #   bytes 1-3:  CHS first sector (zeroed)
    #   byte 4:  partition type (0xEF = EFI System)
    #   bytes 5-7:  CHS last sector (zeroed)
    #   bytes 8-11: LBA start (little-endian uint32)
    #   bytes 12-15: LBA size  (little-endian uint32)
    entry = bytearray(16)
    entry[4] = 0xEF
    struct.pack_into("<I", entry, 8, lba_start)
    struct.pack_into("<I", entry, 12, lba_size)
    buf[446:462] = entry

    with open(output_file, "wb") as f:
        f.write(buf)


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(f"Usage: {sys.argv[0]} <output_file> <lba_start> <lba_size>", file=sys.stderr)
        sys.exit(1)

    create_test_iso(sys.argv[1], int(sys.argv[2]), int(sys.argv[3]))
