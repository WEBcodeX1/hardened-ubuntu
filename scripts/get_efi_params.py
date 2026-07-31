#!/usr/bin/env python3
"""Read EFI System Partition parameters from an ISO partition table.

Searches the MBR partition table first (type 0xEF), then falls back to the
GPT partition table (EFI System Partition GUID).  Modern Ubuntu ISOs (26.04+)
use GPT; older builds used MBR type 0xEF.

Prints two space-separated 512-byte LBA values to stdout:
    <start_sector> <size_in_sectors>

Exit codes:
    0  EFI partition found and parameters printed
    1  EFI partition not found or usage error
"""

import struct
import sys

# MBR
MBR_PARTITION_TABLE_OFFSET = 446
MBR_PARTITION_ENTRY_SIZE = 16
MBR_PARTITION_TABLE_ENTRIES = 4
MBR_EFI_PARTITION_TYPE = 0xEF

# GPT
GPT_HEADER_OFFSET = 512        # LBA 1
GPT_SIGNATURE = b"EFI PART"
GPT_HEADER_SIZE = 92
# EFI System Partition type GUID: C12A7328-F81F-11D2-BA4B-00A0C93EC93B
# Stored on disk in mixed-endian (first three fields little-endian, last two big-endian)
EFI_SYSTEM_PARTITION_GUID = bytes([
    0x28, 0x73, 0x2A, 0xC1,
    0x1F, 0xF8,
    0xD2, 0x11,
    0xBA, 0x4B,
    0x00, 0xA0, 0xC9, 0x3E, 0xC9, 0x3B,
])


def _get_efi_params_mbr(f):
    """Search MBR partition table (offset 446) for a type-0xEF entry."""
    f.seek(MBR_PARTITION_TABLE_OFFSET)
    for _ in range(MBR_PARTITION_TABLE_ENTRIES):
        entry = f.read(MBR_PARTITION_ENTRY_SIZE)
        if len(entry) < MBR_PARTITION_ENTRY_SIZE:
            break
        if entry[4] == MBR_EFI_PARTITION_TYPE:
            start = struct.unpack_from("<I", entry, 8)[0]
            size = struct.unpack_from("<I", entry, 12)[0]
            return start, size
    return None, None


def _get_efi_params_gpt(f):
    """Search GPT partition table (LBA 1) for the EFI System Partition GUID."""
    f.seek(GPT_HEADER_OFFSET)
    header = f.read(GPT_HEADER_SIZE)
    if len(header) < GPT_HEADER_SIZE or header[:8] != GPT_SIGNATURE:
        return None, None

    entries_lba = struct.unpack_from("<Q", header, 72)[0]
    num_entries = struct.unpack_from("<I", header, 80)[0]
    entry_size = struct.unpack_from("<I", header, 84)[0]

    if entry_size < 128 or num_entries == 0:
        return None, None

    f.seek(entries_lba * 512)
    for _ in range(num_entries):
        entry = f.read(entry_size)
        if len(entry) < 128:
            break
        if entry[:16] == EFI_SYSTEM_PARTITION_GUID:
            start = struct.unpack_from("<Q", entry, 32)[0]
            end = struct.unpack_from("<Q", entry, 40)[0]
            size = end - start + 1
            return start, size
    return None, None


def get_efi_params(iso_file):
    """Return (start, size) in 512-byte LBA sectors for the EFI partition.

    Tries MBR first, then GPT.  Returns (None, None) when not found.
    """
    with open(iso_file, "rb") as f:
        start, size = _get_efi_params_mbr(f)
        if start is not None:
            return start, size
        return _get_efi_params_gpt(f)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <iso_file>", file=sys.stderr)
        sys.exit(1)

    start, size = get_efi_params(sys.argv[1])
    if start is None:
        print("EFI partition not found in MBR or GPT", file=sys.stderr)
        sys.exit(1)

    print(start, size)
