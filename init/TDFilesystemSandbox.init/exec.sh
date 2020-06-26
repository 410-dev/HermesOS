#!/bin/bash
echo "[*] Limiting RW permission..."
echo "$(<"$1/rw")" > "$2/rwlim"
echo "[*] Limiting Read permission..."
echo "$(<"$1/read")" > "$2/rlim"
echo "[*] Limiting catalog permission..."
echo "$(<"$1/catalog")" > "$2/clim"
exit 0