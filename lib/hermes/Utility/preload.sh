#!/bin/bash
if [[ ! -f "$SYSTEMSUPPORT/Utility/$(mplxr USER/INTERFACE/START_MODE)" ]]; then
	echo "[*] Unable to locate preload utility."
	while [[ true ]]; do
		sleep 1000
	done
else
	"$SYSTEMSUPPORT/Utility/$(mplxr USER/INTERFACE/START_MODE)"
fi