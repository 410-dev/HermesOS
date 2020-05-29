#!/bin/bash
ASSIGN_ADDRESS="$(md5 -q -s "$(date)")"
echo "[*] Assigning address: $ASSIGN_ADDRESS"
echo "[*] Reserving space on cache drive for swap..."
mkdir -p "$CACHE/tmp/$ASSIGN_ADDRESS"
echo "[*] Writing SIG for Interface..."
echo "$ASSIGN_ADDRESS" > "$CACHE/SIG/swap_address"
echo "[*] Complete."
exit 0