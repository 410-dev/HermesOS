#!/bin/bash
if [[ "$(mplxr SYSTEM/GRAPHITE/ENFORCE_CLI)" == 0 ]] && [[ -z "$(echo $b_arg | grep enforce_cli)" ]]; then
	echo "[*] Starting Graphical setup..."
	while [[ true ]]; do
		export USRNAME="$(graphite_input "What is your name? (English and Number only, no spacebar)")"
		if [[ -z "$USRNAME" ]] || [[ "$USRNAME" == "" ]]; then
			graphite_msgbox "Setup" "Invalid input."
		else
			break
		fi
	done
	"$graphitelib/TDGraphicalUIRenderer" --title "Setup" --yesno "Would you use a passcode?" 0 0
	export PASSPRESENT=$?
	if [[ "$PASSPRESENT" == "0" ]]; then
		export PASS=$("$graphitelib/TDGraphicalUIRenderer" --stdout --passwordbox "Please enter your password. (You may not see your input.)" 0 0)
		mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs $PASS)"
		PASSPRESENT="1"
	else
		mplxw "USER/SECURITY/PASSCODE" "nothing"
	fi
	while [[ true ]]; do
		export DEVN="$(graphite_input "What is your device name? (English and Number only, no spacebar)")"
		if [[ -z "$DEVN" ]] || [[ "$DEVN" == "" ]]; then
			graphite_msgbox "Setup" "Invalid input."
		else
			break
		fi
	done
	graphite_infobox "Writing setup data..."
	mplxw "USER/user_name" "$USRNAME" >/dev/null
	mplxw "USER/SECURITY/PASSCODE_PRESENT" "1" >/dev/null
	echo "Login" > "$MULTIPLEX/USER/INTERFACE/START_MODE"
	mplxw "SYSTEM/DATASETUP_COMPLETE" "Done" >/dev/null
	mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
	mplxw "SYSTEM/COMMON/CONFIGURE_DONE" "TRUE" >/dev/null
	graphite_msgbox "Ready" "System is now ready to go."
	clear
else
	echo "[*] Starting non-graphical setup..."
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
					read PASS
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
	mplxw "SYSTEM/DATASETUP_COMPLETE" "Done" >/dev/null
	mplxw "USER/INTERFACE/START_MODE" "Login" >/dev/null
	mplxw "SYSTEM/COMMON/SetupDone" "" >/dev/null
	mplxw "SYSTEM/COMMON/CONFIGURE_DONE" "TRUE" >/dev/null
fi