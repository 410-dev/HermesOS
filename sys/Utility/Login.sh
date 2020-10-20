#!/bin/bash
if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "nothing" ]] || [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "0" ]]; then
	verbose "[*] Login successful (weak)."
else
	export successful=0
	for (( i = 0; i < 5; i++ )); do
		export PASS="$("$OSSERVICES/hermes/Library/display" --stdout --passwordbox "Login to: $(mplxr "USER/user_name")" 0 0)"
		echo ""
		if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
			echo "[*] Login successful."
			export successful=1
			break
		else
			echo "[-] Login failed."
		fi
	done
	if [[ "$successful" == "0" ]]; then
		mplxw USER/SECURITY/LOGIN_ATTEMPT "64" >/dev/null
	fi
fi