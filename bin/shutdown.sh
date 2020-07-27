#!/bin/bash
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	echo "[*] Requesting shell to close..."
fi
touch "$CACHE/stdown"
exit 0