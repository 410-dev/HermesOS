#!/bin/bash
if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "nothing" ]] || [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "0" ]]; then
	verbose "[*] Login successful (weak)."
else
	if [[ "$(mplxr SYSTEM/GRAPHITE/ENFORCE_CLI)" == "0" ]] && [[ $(bootarg.contains "enforce_cli") == 0 ]]; then
		export successful=0
		for (( i = 0; i < 5; i++ )); do
			export PASS=$("$libcarbondraw/engine" --stdout --passwordbox "Please enter your password." 0 0)
			if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
				verbose "[*] Login successful."
				export successful=1
				clear
				break
			else
				"carbondraw_msgbox" "Login Failed" "Wrong password."
			fi
		done
		if [[ "$successful" == "0" ]]; then
			"$SYSTEMSUPPORT/Utility/Lock" "TooManyLoginAttempt"
		fi
	else
		export successful=0
		for (( i = 0; i < 5; i++ )); do
			echo -n "Please enter your password: "
			read -s PASS
			if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
				echo "[*] Login successful."
				export successful=1
				break
			else
				echo "[-] Login failed."
			fi
		done
		if [[ "$successful" == "0" ]]; then
			"$SYSTEMSUPPORT/Utility/Lock" "TooManyLoginAttempt"
		fi
	fi
fi