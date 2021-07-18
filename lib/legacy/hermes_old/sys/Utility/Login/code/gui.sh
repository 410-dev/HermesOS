#!/bin/bash
sys_log "Login" "Graphical login started."
if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "nothing" ]] || [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "0" ]]; then
	sys_log "Login" "Password is not present."
	verbose "[${GREEN}*${C_DEFAULT}] Login successful."
	sys_log "Login" "Login was successful."
	exit 0
elif [[ -f "$NVRAM/security/autologin" ]] && [[ "$(<"$NVRAM/security/autologin")" == "system" ]]; then
	sys_log "Login" "Autologin is enabled."
	verbose "[${GREEN}*${C_DEFAULT}] Login successful."
	sys_log "Login" "Login was successful."
	exit 0
else
	sys_log "Login" "Password present, login ready."
	export successful=0
	while [[ true ]]; do
		export PASS="$("$OSSERVICES/Library/display" --stdout --passwordbox "[ HermesOS $OS_Version_Major ] Login to: $(mplxr "USER/user_name")" 0 0)"
		echo ""
		if [[ -z "$PASS" ]]; then
			echo -n
		elif [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
			verbose "Login successful."
			sys_log "Login" "Login was successful."
			export successful=1
			clear
			exit 0
		else
			sys_log "Login" "Login failed."
			echo -e "Login failed."
			"$OSSERVICES/Library/display" --msgbox "Login failed." 0 0
			sleep 1
		fi
	done
fi
