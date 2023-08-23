#!/bin/bash
sys_log "Login" "Login started."
if [[ "$(regread USER/Security/LoginPassword)" == "nothing" ]] || [[ "$(regread USER/Security/LoginPasswordEnabled)" == "0" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] Login successful."
	sys_log "Login" "Password is not present."
	sys_log "Login" "Login was successful."
	exit 0
elif [[ "$(regread USER/Security/AUTOLOGIN)" == "system" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] Login successful."
	sys_log "Login" "Autologin is enabled."
	sys_log "Login" "Login was successful."
	exit 0
else
	sys_log "Login" "Password present, login ready."
	export successful=0
	while [[ true ]]; do
		echo -n "Enter password: "
		read -s PASS
		echo ""
		if [[ -z "$PASS" ]]; then
			echo -n
		elif [[ "$(regread USER/Security/LoginPassword)" == "$(md5 -qs $PASS)" ]]; then
			echo -e "Login successful."
			sys_log "Login" "Login was successful."
			export successful=1
			clear
			exit 0
		else
			sys_log "Login" "Login failed."
			echo -e "Login failed."
			sleep 1
		fi
	done
fi