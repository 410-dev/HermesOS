#!/bin/bash
echo "[*] Starting non-graphical setup..."
while [[ true ]]; do
	echo -n "What is your device name? (English and Number only, no spacebar) : "
	read DEVN
	if [[ -z "$DEVN" ]]; then
		echo "[-] Invalid input."
	else
		mplxw "USER/machine_name" "$DEVN" >/dev/null
		break
	fi
done
while [[ true ]]; do
	echo -n "What is your name? (English and Number only, no spacebar) : "
	read USRNAME
	if [[ -z "$USRNAME" ]]; then
		echo "[-] Invalid input."
	else
		mplxw "USER/user_name" "$USRNAME" >/dev/null
		break
	fi
done
echo "[*] Writing configurations..."
mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
mplxw "SYSTEM/DATASETUP_COMPLETE" "Done" >/dev/null
mplxw "USER/INTERFACE/START_MODE" "Login" >/dev/null
mplxw "SYSTEM/COMMON/SetupDone" "" >/dev/null
mplxw "SYSTEM/COMMON/CONFIGURE_DONE" "TRUE" >/dev/null
echo "[*] Done."