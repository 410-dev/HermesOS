#!/bin/bash
echo "[*] Limiting write permission..."
echo "$(<"$1/write")" > "$2/wlim"
echo "[*] Limiting read permission..."
echo "$(<"$1/read")" > "$2/rlim"
echo "[*] Limiting catalog permission..."
echo "$(<"$1/catalog")" > "$2/clim"
exit 0