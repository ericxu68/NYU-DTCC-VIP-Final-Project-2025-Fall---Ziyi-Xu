#!/bin/bash

# ==============================================
# NYU DTCC VIP Final Project - Ziyi Xu
# Automatic SBOM Generator + Dynamic Library Detection
# ==============================================

set -e

# Target command to run with strace for dynamic library capture
TARGET_CMD="$@"

# Output folder
OUT_DIR="output"
STATIC_SBOM="$OUT_DIR/sbom-static.json"
DYNAMIC_LOG="$OUT_DIR/dynamic.log"
DYNAMIC_LIST="$OUT_DIR/dynamic-libs.txt"
MERGED_SBOM="$OUT_DIR/sbom-merged.json"

mkdir -p $OUT_DIR

echo "==============================================="
echo " Step 1: Generate static SBOM using Syft"
echo "==============================================="

# Syft scans current folder to generate static SBOM
syft dir:. -o json > "$STATIC_SBOM"

echo "Static SBOM created at: $STATIC_SBOM"
echo ""

echo "==========================================================="
echo " Step 2: Capture dynamic linked libraries using strace"
echo "==========================================================="

# Capture all opened files and filter .so libraries
strace -f -e trace=file $TARGET_CMD 2>&1 | grep "\.so" > "$DYNAMIC_LOG"

echo "Dynamic library log saved at: $DYNAMIC_LOG"
echo ""

echo "==========================================================="
echo " Step 3: Extract unique shared library paths"
echo "==========================================================="

grep -oE '(/[A-Za-z0-9_\-./]+\.so[^ "]*)' "$DYNAMIC_LOG" | sort -u > "$DYNAMIC_LIST"

echo "Dynamic libraries extracted:"
cat "$DYNAMIC_LIST"
echo ""

echo "==========================================================="
echo " Step 4: Merge dynamic libraries into SBOM"
echo "==========================================================="

python3 merge_sbom.py "$STATIC_SBOM" "$DYNAMIC_LIST" "$MERGED_SBOM"

echo "Merged SBOM created at: $MERGED_SBOM"
echo ""
echo "==========================================================="
echo " Completed Successfully"
echo "==========================================================="
