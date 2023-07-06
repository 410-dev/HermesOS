#!/bin/bash
sys_log "Authenticator" "Requested for password authentication."
if [[ "$(mplxr USER/Security/LoginPassword)" == "nothing" ]] || [[ "$(mplxr USER/Security/LoginPasswordEnabled)" == "0" ]]; then
	sys_log "Authenticator" "No password present, authentication successful."
	verbose "[${GREEN}*${C_DEFAULT}] Authentication successful."
	exit 0
else
	export successful=0
	for (( i = 0; i < 3; i++ )); do
		echo -n "Please enter your password: "
		read -s PASS
		echo ""
		if [[ -z "$PASS" ]]; then
			echo -n
			sys_log "Authenticator" "Input is empty."
		elif [[ "$(mplxr USER/Security/LoginPassword)" == "$(md5 -qs $PASS)" ]]; then
			echo "Authentication successful."
			sys_log "Authenticator" "Authentication was successful."
			export successful=1
			exit 0
		else
			echo "Authentication failed."
			sys_log "Authenticator" "Authentication failed: $i"
			sleep 1
		fi
	done
fi