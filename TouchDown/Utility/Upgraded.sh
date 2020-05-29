#!/bin/bash
if [[ "$(mplxr SYSTEM/GRAPHITE/ENFORCE_CLI)" == 0 ]] && [[ -z "$(echo $b_arg | grep enforce_cli)" ]]; then
	echo "[*] Starting Graphical setup..."
	graphite_infobox "Welcome."
	sleep 3
	graphite_msgbox "Setup" "TouchDown OS is upgraded. Data restructure process is required. This process may take some time."
	sleep 6
	mplxw "USER/INTERFACE/START_MODE" "Login"
	mplxw "SYSTEM/COMMON/SetupDone" ""
	graphite_infobox "Done."
else
	echo "[*] Starting non-graphical setup..."
	echo "TouchDown OS is upgraded."
	echo "Data restructure process is required."
	echo "This process may take some time."
	sleep 5
	mplxw "USER/INTERFACE/START_MODE" "Login"
	mplxw "SYSTEM/COMMON/SetupDone" ""
	echo "Done."
fi