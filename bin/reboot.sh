#!/bin/bash
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	echo "[*] Requesting shell to close..."
fi
touch "$CACHE/rboot"
exit 0