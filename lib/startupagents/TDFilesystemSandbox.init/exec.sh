#!/bin/bash
echo "[*] Limiting write permission..."
echo "$(<"$(dirname "$0")/write")" > "$CACHE/wlim"
echo "[*] Limiting read permission..."
echo "$(<"$(dirname "$0")/read")" > "$CACHE/rlim"
echo "[*] Limiting catalog permission..."
echo "$(<"$(dirname "$0")/catalog")" > "$CACHE/clim"
exit 0