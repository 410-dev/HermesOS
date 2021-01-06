#!/bin/bash
if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "nothing" ]] || [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "0" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] Login successful."
	exit 0
elif [[ -f "$NVRAM/security/autologin" ]] && [[ "$(<"$NVRAM/security/autologin")" == "system" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] Login successful."
	exit 0
else
	export successful=0
	for (( i = 0; i < 5; i++ )); do
		echo -n "Enter password: "
		read -s PASS
		echo ""
		if [[ -z "$PASS" ]]; then
			echo -n
		elif [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
			echo -e "Login successful."
			export successful=1
			clear
			exit 0
		else
			echo -e "Login failed."
			sleep 1
		fi
	done
	mplxw USER/SECURITY/LOGIN_ATTEMPT "64" >/dev/null
fi