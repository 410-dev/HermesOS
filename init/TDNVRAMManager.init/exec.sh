#!/bin/bash
if [[ -f "$NVRAM/nvraminfo" ]]; then
	if [[ -z "$(cat $NVRAM/nvraminfo | grep "COMPATIBILITY=NVRV01XU")" ]]; then
		echo "[*] NVRAM is incompatible. Resetting NVRAM."
		rm -rf "$NVRAM"
		mkdir -p "$NVRAM"
		echo "[*] Rewriting NVRAM..."
		cp -r "$TDLIB/defaults/nvram" "$DATA/"
		echo "[*] Done."
	fi
else
	echo "[*] Initializing NVRAM data..."
	mkdir -p "$NVRAM"
	cp -r "$TDLIB/defaults/nvram" "$DATA/"
	echo "[*] Done."
fi