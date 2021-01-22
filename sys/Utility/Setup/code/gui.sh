#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Starting graphical setup..."
sys_log "Setup" "Graphical setup started."
"$BundlePath/code/langset_gui"
sys_log "Setup" "Reading language data..."
source "$LIBRARY/Preferences/Language/setup.hlang"
sys_log "Setup" "Setting up name..."
while [[ true ]]; do
	sys_log "Setup" "Asking for input..."
	export USRNAME="$("$OSSERVICES/Library/display" --stdout --inputbox "${SETUP_ASK_NAME}" 0 0)"
	if [[ -z "$USRNAME" ]]; then
		echo "${SETUP_INVALID_INPUT}"
		sys_log "Setup" "Invalid input for username."
	else
		sys_log "Setup" "Setting username: $USRNAME"
		mplxw "USER/user_name" "$USRNAME" >/dev/null
		break
	fi
done
sys_log "Setup" "Setting up device name..."
while [[ true ]]; do
	sys_log "Setup" "Asking for input..."
	export DEVN="$("$OSSERVICES/Library/display" --stdout --inputbox "${SETUP_ASK_DEVNAME}" 0 0)"
	if [[ -z "$DEVN" ]]; then
		sys_log "Setup" "Invalid input for device name."
		echo "${SETUP_INVALID_INPUT}"
	else
		sys_log "Setup" "Setting device name: $DEVN"
		mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
		break
	fi
done
sys_log "Setup" "Setting password..."
"$OSSERVICES/Library/display" --title "${SETUP}" --yesno "${SETUP_ASK_PASSBOOL}" 0 0
export PASSPRESENT=$?
if [[ "$PASSPRESENT" == "0" ]]; then
	sys_log "Setup" "Password present."
	export PASSPRESENT="1"
else
	sys_log "Setup" "Password absent."
	export PASSPRESENT="0"
fi
sys_log "Setup" "Writing password flag..."
mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
sys_log "Setup" "Asking for new password..."
sys_log "Setup" "Log will be stopped temporarily for security reason."
while [[ "$PASSPRESENT" == "1" ]]; do
	if [[ "$PASSPRESENT" == "1" ]]; then
		clear
		echo -n "${SETUP_ASK_PASSWORD}"
		read -s PASS
		echo ""
		if [[ -z "$PASS" ]]; then
			echo "${SETUP_INVALID_INPUT}"
		else
			mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs $PASS)" >/dev/null
			break
		fi
	fi
done
sys_log "Setup" "OK"
sys_log "Setup" "Setting up Pro System..."
"$OSSERVICES/Library/display" --title "${SETUP}" --yesno "${SETUP_ENABLE_PROSYSTEM}" 0 0
export PROSYS=$?
if [[ "$PROSYS" == "0" ]]; then
	sys_log "Setup" "Pro System enabled."
	export PROSYS="1"
else
	sys_log "Setup" "Pro System disabled."
	export PROSYS="0"
fi
sys_log "Setup" "Setting security data..."
if [[ "$PROSYS" == "1" ]]; then
	mkdir -p "$NVRAM/security"
	echo "Pro System" > "$NVRAM/security/prosys"
	echo "Unlocked" > "$NVRAM/security/lockstate"
elif [[ "$PROSYS" == "0" ]]; then
	mkdir -p "$NVRAM/security"
	echo "Default" > "$NVRAM/security/prosys"
	echo "Locked" > "$NVRAM/security/lockstate"
fi
sys_log "Setup" "Setting auto login..."
if [[ "$PROSYS" == 1 ]] && [[ "$PASSPRESENT" == "1" ]]; then
	"$OSSERVICES/Library/display" --title "${SETUP}" --yesno "${SETUP_ENABLE_AUTOLOGIN}" 0 0
	export AUTOLOGIN=$?
	if [[ "$AUTOLOGIN" == "0" ]]; then
		sys_log "Setup" "Auto login is enabled."
		export AUTOLOGIN="1"
	else
		sys_log "Setup" "Auto login is disabled."
		export AUTOLOGIN="0"
	fi
	if [[ "$AUTOLOGIN" == "1" ]]; then
		mkdir -p "$NVRAM/security"
		echo "system" > "$NVRAM/security/autologin"
	elif [[ "$AUTOLOGIN" == "0" ]]; then
		mkdir -p "$NVRAM/security"
		echo "" > "$NVRAM/security/autologin"
	fi
fi
"$BundlePath/code/writer"
clear