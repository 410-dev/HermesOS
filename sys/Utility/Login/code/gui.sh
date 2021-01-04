#!/bin/bash
if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "nothing" ]] || [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "0" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] Login successful."
	exit 0
else
	export successful=0
	for (( i = 0; i < 5; i++ )); do
		export PASS="$("$OSSERVICES/Library/display" --stdout --passwordbox "[ HermesOS $OS_Version_Major ] Login to: $(mplxr "USER/user_name")" 0 0)"
		echo ""
		if [[ -z "$PASS" ]]; then
			echo -n
		elif [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
			verbose "Login successful."
			export successful=1
			clear
			exit 0
		else
			echo -e "Login failed."
			"$OSSERVICES/Library/display" --infobox "Login failed." 0 0
			sleep 1
		fi
	done
	mplxw USER/SECURITY/LOGIN_ATTEMPT "64" >/dev/null
fi
