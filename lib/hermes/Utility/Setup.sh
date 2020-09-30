#!/bin/bash
verbose "[*] Starting non-graphical setup..."
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
while [[ true ]]; do
	echo -n "Would you use a passcode? 0 (No)/1 (Yes) : "
	read PASSPRESENT
	if [[ "$PASSPRESENT" == 0 ]]; then
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
		break
	elif [[ "$PASSPRESENT" == 1 ]]; then
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
		while [[ true ]]; do
			if [[ "$PASSPRESENT" == "1" ]]; then
				echo -n "What is your password? : "
				read -s PASS
				echo ""
				if [[ -z "$PASS" ]]; then
					echo "[-] Invalid input."
				else
					mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs $PASS)" >/dev/null
					break
				fi
			fi
		done
		break
	else
		echo "[-] Invalid input."
	fi
done
echo "[*] Writing configurations..."
mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
mplxw "SYSTEM/DATASETUP_COMPLETE" "Done" >/dev/null
mplxw "USER/INTERFACE/START_MODE" "Login" >/dev/null
mplxw "SYSTEM/COMMON/SetupDone" "" >/dev/null
mplxw "SYSTEM/COMMON/CONFIGURE_DONE" "TRUE" >/dev/null
echo "[*] Done."