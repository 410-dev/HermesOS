#!/bin/bash
export DATA_COMPATIBILITY="11"
if [[ "$(mplxr SYSTEM/DATASETUP_COMPLETE)" == "null" ]]; then
	echo "[*] Start data partition repair!"
	rm -rf "$DATA/config" 2>/dev/null
	rm -rf "$DATA/logs" 2>/dev/null
	rm -rf "$DATA/nvcache" 2>/dev/null
	cp -r "$SYSTEM/TouchDown/defaults/multiplex" "$DATA/"
	mv "$DATA/multiplex" "$DATA/config"
	mkdir -p "$DATA/nvcache"
	cp -r "$SYSTEM/TouchDown/defaults/nvram" "$DATA/"
	mkdir -p "$DATA/init"
	mplxw USER/INTERFACE/ALERT "" >/dev/null
	mplxw USER/INTERFACE/ALERT_PRESENT 0 >/dev/null
	mplxw USER/INTERFACE/START_MODE Setup >/dev/null
	mplxw BOOT/PROTOCOL/EnterSafeMode 0 >/dev/null
	mplxw SYSTEM/GRAPHITE/present 1 >/dev/null
	mplxw SYSTEM/COMMON/DataCompatibility "$DATA_COMPATIBILITY" >/dev/null
elif [[ "$(mplxr SYSTEM/COMMON/DataCompatibility)" -ne "$DATA_COMPATIBILITY" ]]; then
	echo "[*] Upgrading data partition."
	cp -r "$DATA/config" "$DATA/config.old"
	mkdir -p "$DATA/mount"
else
	echo "[*] No task for data partition modification."
fi
exit 0