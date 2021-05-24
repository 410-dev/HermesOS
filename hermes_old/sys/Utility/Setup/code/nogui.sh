#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Starting non-graphical setup..."
sys_log "Setup" "Graphical setup started."
ls -1 "$OSSERVICES/Default/Languages"
while [[ true ]]; do
	echo ""
	echo "${SETUP_KEEP_LANG}"
	echo -n "${SETUP_CHOOSE_LANG}"
	read language
	if [[ -z "$language" ]]; then
		echo "${SETUP_LANG_SELECTED} ${LANG_ID}"
	elif [[ -d "$OSSERVICES/Default/Languages/$language" ]]; then
		echo "${SETTING_LANGUAGE}"
		cp "$OSSERVICES/Default/Languages/$language/"* "$LIBRARY/Preferences/Language/"
		source "$LIBRARY/Preferences/Language/setup.hlang"
		echo "${SETUP_LANGUAGE_CHANGED}"
	else
		echo "${SETUP_NO_SUCH_LANG}"
	fi
done
sys_log "Setup" "Reading language data..."
source "$LIBRARY/Preferences/Language/setup.hlang"
sys_log "Setup" "Setting up name..."
while [[ true ]]; do
	sys_log "Setup" "Asking for input..."
	echo -n ""
	read USRNAME
	if [[ -z "$USRNAME" ]]; then
		echo "[-] ${SETUP_INVALID_INPUT}"
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
	echo -n "${SETUP_ASL_DEVNAME}"
	read DEVN
	if [[ -z "$DEVN" ]]; then
		sys_log "Setup" "Invalid input for device name."
		echo "[-] ${SETUP_INVALID_INPUT}"
	else
		sys_log "Setup" "Setting device name: $DEVN"
		mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
		break
	fi
done
sys_log "Setup" "Setting password..."
while [[ true ]]; do
	echo -n "${SETUP_ASK_PASSBOOL}"
	read PASSPRESENT
	if [[ "$PASSPRESENT" == 0 ]]; then
		sys_log "Setup" "Password absent."
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
		break
	elif [[ "$PASSPRESENT" == 1 ]]; then
		sys_log "Setup" "Password present."
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
		sys_log "Setup" "Asking for new password..."
		sys_log "Setup" "Log will be stopped temporarily for security reason."
		while [[ true ]]; do
			if [[ "$PASSPRESENT" == "1" ]]; then
				echo -n "${SETUP_ASK_PASSWORD}"
				read -s PASS
				echo ""
				if [[ -z "$PASS" ]]; then
					echo "[-] ${SETUP_INVALID_INPUT}"
				else
					mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs $PASS)" >/dev/null
					break
				fi
			fi
		done
		break
	else
		echo "[-] ${SETUP_INVALID_INPUT}"
	fi
done
sys_log "Setup" "OK"
sys_log "Setup" "Setting up Pro System..."
while [[ true ]]; do
	echo -n "${SETUP_ENABLE_PROSYSTEM}"
	read yn
	if [[ -z "$yn" ]]; then
		echo "[-] ${SETUP_INVALID_INPUT}"
	elif [[ "$yn" == "YES" ]] || [[ "$yn" == "Yes" ]] || [[ "$yn" == "yes" ]]; then
		sys_log "Setup" "Pro System enabled."
		mkdir -p "$NVRAM/security"
		echo "Pro System" > "$NVRAM/security/prosys"
		echo "Unlocked" > "$NVRAM/security/lockstate"
		break
	elif [[ "$yn" == "NO" ]] || [[ "$yn" == "No" ]] || [[ "$yn" == "no" ]]; then
		sys_log "Setup" "Pro System disabled."
		mkdir -p "$NVRAM/security"
		echo "Default" > "$NVRAM/security/prosys"
		echo "Locked" > "$NVRAM/security/lockstate"
		break
	else
		sys_log "Setup" "Invalid input."
		echo "[-] ${SETUP_INVALID_INPUT}"
	fi
done
sys_log "Setup" "Setting auto login..."
if [[ "$PROSYS" == 1 ]] && [[ "$PASSPRESENT" == "1" ]]; then
	while [[ true ]]; do
		echo -n "${SETUP_ENABLE_AUTOLOGIN}"
		read AUTOLOGIN
		if [[ "$AUTOLOGIN" == "YES" ]] || [[ "$AUTOLOGIN" == "Yes" ]] || [[ "$AUTOLOGIN" == "yes" ]]; then
			sys_log "Setup" "Auto login is enabled."
			mkdir -p "$NVRAM/security"
			echo "system" > "$NVRAM/security/autologin"
			break
		elif [[ "$AUTOLOGIN" == "NO" ]] || [[ "$AUTOLOGIN" == "No" ]] || [[ "$AUTOLOGIN" == "no" ]]; then
			sys_log "Setup" "Auto login is disabled."
			mkdir -p "$NVRAM/security"
			echo "" > "$NVRAM/security/autologin"
			break
		else
			echo "[-] ${SETUP_INVALID_INPUT}"
		fi
	done
fi
"$BundlePath/code/writer"