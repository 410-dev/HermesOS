#!/bin/bash
if [[ ! -f "$SYSTEM/TouchDown/Utility/$(mplxr USER/INTERFACE/START_MODE)" ]]; then
	echo "[*] Unable to locate preload utility."
	while [[ true ]]; do
		sleep 1000
	done
else
	"$SYSTEM/TouchDown/Utility/$(mplxr USER/INTERFACE/START_MODE)"
fi