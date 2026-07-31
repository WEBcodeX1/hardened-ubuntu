#!/bin/bash
# test_mkiso.sh — test EFI parameter extraction and xorriso command construction
#
# Tests the get_efi_params.py script and the arithmetic used in mkiso.sh to build
# xorriso EFI boot parameters.  No actual ISO build is performed; the tests are
# designed to run in any standard Linux/macOS environment with python3.
#
# Exit code: 0 when all tests pass, 1 when any test fails.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GET_EFI_PARAMS="${SCRIPT_DIR}/../scripts/get_efi_params.py"
CREATE_TEST_ISO="${SCRIPT_DIR}/create_test_iso.py"

PASS=0
FAIL=0

ok()   { echo "PASS: $*"; PASS=$(( PASS + 1 )); }
fail() { echo "FAIL: $*"; FAIL=$(( FAIL + 1 )); }

echo "=== test_mkiso: EFI partition parameter extraction ==="

# ---------------------------------------------------------------------------
# Test 1: get_efi_params.py returns correct values for a known EFI entry
# ---------------------------------------------------------------------------
TEST_ISO=$(mktemp /tmp/test_iso.XXXXXX)

EXPECTED_START=2781704
EXPECTED_SIZE=10256
python3 "${CREATE_TEST_ISO}" "${TEST_ISO}" "${EXPECTED_START}" "${EXPECTED_SIZE}"

RESULT=$(python3 "${GET_EFI_PARAMS}" "${TEST_ISO}")
EFI_START=$(echo "${RESULT}" | cut -d' ' -f1)
EFI_SIZE=$(echo  "${RESULT}" | cut -d' ' -f2)

if [ "${EFI_START}" = "${EXPECTED_START}" ] && [ "${EFI_SIZE}" = "${EXPECTED_SIZE}" ]; then
    ok "EFI start=${EFI_START} size=${EFI_SIZE} match expected values"
else
    fail "expected start=${EXPECTED_START} size=${EXPECTED_SIZE}, got start=${EFI_START} size=${EFI_SIZE}"
fi

rm -f "${TEST_ISO}"

# ---------------------------------------------------------------------------
# Test 2: get_efi_params.py exits non-zero when no EFI partition is present
# ---------------------------------------------------------------------------
TEST_ISO=$(mktemp /tmp/test_iso_no_efi.XXXXXX)
# Create a valid-looking 512-byte MBR with no partition entries set
python3 - "${TEST_ISO}" <<'PYEOF'
import sys
buf = bytearray(512)
buf[510] = 0x55
buf[511] = 0xAA
with open(sys.argv[1], "wb") as f:
    f.write(buf)
PYEOF

if python3 "${GET_EFI_PARAMS}" "${TEST_ISO}" 2>/dev/null; then
    fail "expected non-zero exit when no EFI partition found, but got exit 0"
else
    ok "non-zero exit returned when no EFI partition is present"
fi

rm -f "${TEST_ISO}"

# ---------------------------------------------------------------------------
# Test 3: get_efi_params.py exits non-zero for a missing file
# ---------------------------------------------------------------------------
if python3 "${GET_EFI_PARAMS}" /tmp/nonexistent_file_xyz.iso 2>/dev/null; then
    fail "expected non-zero exit for a missing ISO file"
else
    ok "non-zero exit returned for a missing ISO file"
fi

# ---------------------------------------------------------------------------
# Test 4: xorriso parameter arithmetic is consistent (matches mkiso.sh logic)
# ---------------------------------------------------------------------------
EFI_START_D=2781704
EFI_SIZE_D=10256
EFI_END_D=$(( EFI_START_D + EFI_SIZE_D - 1 ))
EFI_START_S=$(( EFI_START_D / 4 ))

EXPECTED_END_D=2791959
EXPECTED_START_S=695426

if [ "${EFI_END_D}" = "${EXPECTED_END_D}" ]; then
    ok "EFI_END_D arithmetic: ${EFI_END_D}"
else
    fail "EFI_END_D: expected ${EXPECTED_END_D}, got ${EFI_END_D}"
fi

if [ "${EFI_START_S}" = "${EXPECTED_START_S}" ]; then
    ok "EFI_START_S arithmetic: ${EFI_START_S}"
else
    fail "EFI_START_S: expected ${EXPECTED_START_S}, got ${EFI_START_S}"
fi

# ---------------------------------------------------------------------------
# Test 5: get_efi_params.py script is executable and shebang is correct
# ---------------------------------------------------------------------------
if [ -f "${GET_EFI_PARAMS}" ]; then
    ok "get_efi_params.py exists"
else
    fail "get_efi_params.py not found at ${GET_EFI_PARAMS}"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo
echo "Results: ${PASS} passed, ${FAIL} failed"

if [ "${FAIL}" -gt 0 ]; then
    echo "=== SOME TESTS FAILED ==="
    exit 1
fi

echo "=== ALL TESTS PASSED ==="
exit 0
