#!/bin/bash
if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "nothing" ]] || [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "0" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] $2 successful."
	exit 0
else
	export successful=0
	for (( i = 0; i < 5; i++ )); do
		export PASS="$("$OSSERVICES/hermes/Library/display" --stdout --passwordbox "$2 to: $(mplxr "USER/user_name")" 0 0)"
		echo ""
		if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
			echo -e "$2 successful."
			export successful=1
			exit 0
		else
			echo -e "$2 failed."
			"$OSSERVICES/hermes/Library/display" --infobox "$2 failed." 0 0
			sleep 1
		fi
	done
	if [[ "$successful" == "0" ]]; then
		if [[ "$1" == "--login" ]]; then
			mplxw USER/SECURITY/LOGIN_ATTEMPT "64" >/dev/null
		fi
		exit 1
	fi
fi