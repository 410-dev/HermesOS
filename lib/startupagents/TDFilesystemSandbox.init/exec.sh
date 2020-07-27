#!/bin/bash
mkdir -p "$CACHE/proc.faccess"
echo "[*] Limiting write permission..."
echo "$(<"$(dirname "$0")/write")" > "$CACHE/proc.faccess/wlim"
echo "[*] Limiting read permission..."
echo "$(<"$(dirname "$0")/read")" > "$CACHE/proc.faccess/rlim"
echo "[*] Limiting catalog permission..."
echo "$(<"$(dirname "$0")/catalog")" > "$CACHE/proc.faccess/clim"
exit 0