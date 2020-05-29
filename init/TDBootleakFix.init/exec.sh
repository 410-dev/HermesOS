#!/bin/bash
echo "[*] Detecting bootleak..."
if [[ -f "/tmp/vmstart_exported" ]]; then
	echo "[*] Removing..."
	rm -f "/tmp/vmstart_exported"
else
	echo "[*] Bootleak not found."
fi
exit 0