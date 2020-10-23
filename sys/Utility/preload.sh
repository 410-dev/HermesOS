#!/bin/bash
clear
echo "HermesOS $OS_Version"
if [[ ! -f "$OSSERVICES/Utility/$(mplxr USER/INTERFACE/START_MODE)" ]]; then
	echo "[*] Unable to locate preload utility."
	while [[ true ]]; do
		sleep 1000
	done
else
	"$OSSERVICES/Utility/$(mplxr USER/INTERFACE/START_MODE)" --login "Login"
fi