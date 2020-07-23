#!/bin/bash
echo "[*] Copying quarantine data..."
cp "$1/disabledContents" "$2/"
echo "[*] Done."
exit 0