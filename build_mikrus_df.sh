#!/bin/bash
# Build mikrus_df firmware and collect all debug/flash/tune artifacts
# into dist/mikrus_df/ for easy transfer to a Windows debug machine.
#
# Usage:
#   ./build_mikrus_df.sh
#   ./build_mikrus_df.sh -j12           # override thread count (default: nproc)
#
# After a successful build, copy to Windows with:
#   scp dist/mikrus_df/* user@windows-host:/path/to/fome-fw/firmware/build/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FW_DIR="$SCRIPT_DIR/firmware"
BOARD="mikrus_df"
OUT_DIR="$SCRIPT_DIR/dist/$BOARD"

# Allow overriding thread count, default to nproc
JOBS="${1:--j$(nproc)}"

echo "========================================"
echo "  Building $BOARD  ($JOBS)"
echo "========================================"

cd "$FW_DIR/config/boards/$BOARD"
bash "compile_${BOARD}.sh"

echo ""
echo "========================================"
echo "  Collecting artifacts → $OUT_DIR"
echo "========================================"
mkdir -p "$OUT_DIR"

# ELF with debug symbols (needed for Cortex-Debug / GDB)
cp "$FW_DIR/build/fome.elf"                               "$OUT_DIR/fome.elf"

# Bootloader ELF with debug symbols (for "Attach Bootloader" debug config)
cp "$FW_DIR/bootloader/blbuild/fome_bl.elf"               "$OUT_DIR/fome_bl.elf"

# Flash images
cp "$FW_DIR/deliver/fome.bin"                             "$OUT_DIR/fome.bin"
cp "$FW_DIR/deliver/fome_update.srec"                     "$OUT_DIR/fome_update.srec"

# TunerStudio / FOME Console INI (must match this exact firmware build)
cp "$FW_DIR/tunerstudio/generated/fome_${BOARD}.ini"      "$OUT_DIR/fome_${BOARD}.ini"

echo ""
ls -lh "$OUT_DIR"
echo ""
echo "Done. To copy to Windows:"
echo "  scp dist/$BOARD/fome.elf dist/$BOARD/fome_bl.elf user@windows-host:/path/to/fome-fw/firmware/build/"
