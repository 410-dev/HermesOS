#!/bin/bash
if [[ $(bootarg.contains "verbose") == 1 ]]; then
	echo "[*] Requesting shell to close..."
fi
touch "$CACHE/rboot"
exit 0