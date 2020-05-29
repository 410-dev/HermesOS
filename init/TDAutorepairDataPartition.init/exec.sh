#!/bin/bash
export DATA_COMPATIBILITY="10"
if [[ "$(mplxr SYSTEM/DATASETUP_COMPLETE)" == "null" ]]; then
	echo "[*] Start data partition repair!"
	rm -rf "$DATA/config" 2>/dev/null
	rm -rf "$DATA/logs" 2>/dev/null
	rm -rf "$DATA/nvcache" 2>/dev/null
	cp -r "$SYSTEM/TouchDown/multiplex" "$DATA/"
	mv "$DATA/multiplex" "$DATA/config"
	mkdir -p "$DATA/nvcache"
	mkdir -p "$DATA/init"
	mplxw USER/INTERFACE/ALERT "" >/dev/null
	mplxw USER/INTERFACE/ALERT_PRESENT 0 >/dev/null
	mplxw USER/INTERFACE/START_MODE Setup >/dev/null
	mplxw BOOT/PROTOCOL/EnterSafeMode 0 >/dev/null
	mplxw SYSTEM/GRAPHITE/present 1 >/dev/null
	mplxw SYSTEM/COMMON/DataCompatibility "$DATA_COMPATIBILITY" >/dev/null
elif [[ "$(mplxr SYSTEM/COMMON/DataCompatibility)" -ne "$DATA_COMPATIBILITY" ]]; then
	echo "[*] Data partition must be restructured."
	mv "$DATA/config" "$DATA/config.old"
	mkdir -p "$DATA/init"
	cp -r "$SYSTEM/TouchDown/multiplex" "$DATA/"
	mplxw SYSTEM/machine_name "$(<$DATA/config.old/SYSTEM/machine_name)" >/dev/null
	mplxw USER/user_name "$(<$DATA/config.old/USER/user_name)" >/dev/null
	mplxw USER/SECURITY/PASSCODE "$(<$DATA/config.old/USER/SECURITY/PASSCODE)" >/dev/null
	mplxw USER/SECURITY/PASSCODE_PRESENT "$(<$DATA/config.old/USER/SECURITY/PASSCODE_PRESENT)" >/dev/null
else
	echo "[*] No task for data partition modification."
fi
exit 0