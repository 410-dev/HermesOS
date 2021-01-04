#!/bin/bash
if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "nothing" ]] || [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "0" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] Authentication successful."
	exit 0
else
	export successful=0
	for (( i = 0; i < 5; i++ )); do
		echo -n "Please enter your password: "
		read -s PASS
		echo ""
		if [[ -z "$PASS" ]]; then
			echo -n
		elif [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
			echo "Authentication successful."
			export successful=1
			exit 0
		else
			echo "Authentication failed."
			sleep 1
		fi
	done
fi