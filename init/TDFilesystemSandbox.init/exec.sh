#!/bin/bash
echo "[*] Limiting RW permission to $(<"$1/limitTo")..."
touch "$2/writable"
echo "$(<"$1/limitTo")" > "$2/writable"
exit 0