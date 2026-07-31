#!/usr/bin/env python3
"""Read EFI System Partition parameters from an ISO MBR partition table.

Prints two space-separated 512-byte LBA values to stdout:
    <start_sector> <size_in_sectors>

Exit codes:
    0  EFI partition found and parameters printed
    1  EFI partition not found or usage error
"""

import struct
import sys

MBR_PARTITION_TABLE_OFFSET = 446
PARTITION_ENTRY_SIZE = 16
PARTITION_TABLE_ENTRIES = 4
EFI_PARTITION_TYPE = 0xEF


def get_efi_params(iso_file):
    """Return (start, size) in 512-byte sectors for the EFI partition.

    Returns (None, None) when no EFI partition entry is found.
    """
    with open(iso_file, "rb") as f:
        f.seek(MBR_PARTITION_TABLE_OFFSET)
        for _ in range(PARTITION_TABLE_ENTRIES):
            entry = f.read(PARTITION_ENTRY_SIZE)
            if len(entry) < PARTITION_ENTRY_SIZE:
                break
            if entry[4] == EFI_PARTITION_TYPE:
                start = struct.unpack_from("<I", entry, 8)[0]
                size = struct.unpack_from("<I", entry, 12)[0]
                return start, size
    return None, None


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <iso_file>", file=sys.stderr)
        sys.exit(1)

    start, size = get_efi_params(sys.argv[1])
    if start is None:
        print("EFI partition not found in MBR", file=sys.stderr)
        sys.exit(1)

    print(start, size)
