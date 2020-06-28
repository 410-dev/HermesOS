#!/bin/bash
echo "[*] Loading viewable frameworks..."
if [[ ! -f "$CACHE/upgraded" ]]; then
	"$SYSTEM/TouchDown/Services/TDFrameworks/TDUserViewableFramework"
else
	echo "[*] Upgrade protocol. Skipping extended framework loader."
fi
exit 0
