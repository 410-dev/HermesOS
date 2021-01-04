#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Starting non-graphical setup..."
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
	echo -n "What is your device name? (English and Number only, no spacebar) : "
	read DEVN
	if [[ -z "$DEVN" ]]; then
		echo "[-] Invalid input."
	else
		mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
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
"$BundlePath/code/writer"