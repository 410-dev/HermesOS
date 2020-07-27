#!/bin/bash
if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "nothing" ]] || [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "0" ]]; then
	echo "[*] Login successful (weak)."
else
	if [[ "$(mplxr SYSTEM/GRAPHITE/ENFORCE_CLI)" == "0" ]] && [[ $(bootarg.contains "enforce_cli") == 0 ]]; then
		while [[ true ]]; do
			export PASS=$("$graphitelib/TDGraphicalUIRenderer" --stdout --passwordbox "Please enter your password." 0 0)
			if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
				echo "[*] Login successful."
				clear
				break
			else
				graphite_msgbox "Login Failed" "Wrong password."
			fi
		done
	else
		while [[ true ]]; do
			echo -n "Please enter your password: "
			read PASS
			if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
				echo "[*] Login successful."
				break
			else
				echo "[-] Login failed."
			fi
		done
	fi
fi