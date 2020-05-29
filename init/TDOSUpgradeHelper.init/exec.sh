#!/bin/bash

if [[ ! -f "$PWD/cache/update-install" ]]; then
	echo "[*] No request."
	exit 0
else
	echo "Update detected."
	echo "Currently unsupported feature. Please use installer included in the package."
	rm "$PWD/cache/update-install"
	exit 99
fi