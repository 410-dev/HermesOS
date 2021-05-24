#!/bin/bash
if [[ "$HUID" -ne 0 ]]; then
	echo "${PERMISSION_DENIED}$HUID"
	exit 0
fi

if [[ $(bootArgumentHas "verbose") == 1 ]]; then
	echo "[*] Requesting shell to close..."
fi
touch "$CACHE/rboot"
exit 0