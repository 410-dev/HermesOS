#!/bin/bash
if [[ "$HUID" -ne 0 ]]; then
	echo "Permission denied: $HUID"
	exit 0
fi

if [[ $(bootarg.contains "verbose") == 1 ]]; then
	echo "[*] Requesting shell to close..."
fi
touch "$CACHE/rboot"
exit 0