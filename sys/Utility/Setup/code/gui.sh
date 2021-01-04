#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Starting graphical setup..."
while [[ true ]]; do
	export USRNAME="$("$SYSTEM/sys/Library/display" --stdout --inputbox "What is your name?" 0 0)"
	if [[ -z "$USRNAME" ]]; then
		echo "[-] Invalid input."
	else
		mplxw "USER/user_name" "$USRNAME" >/dev/null
		break
	fi
done
while [[ true ]]; do
	export DEVN="$("$SYSTEM/sys/Library/display" --stdout --inputbox "What is your device name?" 0 0)"
	if [[ -z "$DEVN" ]]; then
		echo "[-] Invalid input."
	else
		mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
		break
	fi
done
"$SYSTEM/sys/Library/display" --title "Setup" --yesno "Would you use a passcode?" 0 0
export PASSPRESENT=$?
if [[ "$PASSPRESENT" == "0" ]]; then
	export PASSPRESENT="1"
else
	export PASSPRESENT="0"
fi
mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
while [[ "$PASSPRESENT" == "1" ]]; do
	if [[ "$PASSPRESENT" == "1" ]]; then
		clear
		echo -n "What is your password?: "
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
"$BundlePath/code/writer"
clear