#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Starting non-graphical setup..."
ls -1 "$SYSTEM/sys/Default/Languages"
while [[ true ]]; do
	echo ""
	echo "${SETUP_KEEP_LANG}"
	echo -n "${SETUP_CHOOSE_LANG}"
	read language
	if [[ -z "$language" ]]; then
		echo "${SETUP_LANG_SELECTED} ${LANG_ID}"
	elif [[ -d "$SYSTEM/sys/Default/Languages/$language" ]]; then
		echo "${SETTING_LANGUAGE}"
		cp "$SYSTEM/sys/Default/Languages/$language/"* "$LIBRARY/Preferences/Language/"
		source "$LIBRARY/Preferences/Language/system.hlang"
		echo "${SETUP_LANGUAGE_CHANGED}"
	else
		echo "${SETUP_NO_SUCH_LANG}"
	fi
done
while [[ true ]]; do
	echo -n ""
	read USRNAME
	if [[ -z "$USRNAME" ]]; then
		echo "[-] ${SETUP_INVALID_INPUT}"
	else
		mplxw "USER/user_name" "$USRNAME" >/dev/null
		break
	fi
done
while [[ true ]]; do
	echo -n "${SETUP_ASL_DEVNAME}"
	read DEVN
	if [[ -z "$DEVN" ]]; then
		echo "[-] ${SETUP_INVALID_INPUT}"
	else
		mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
		break
	fi
done
while [[ true ]]; do
	echo -n "${SETUP_ASK_PASSBOOL}"
	read PASSPRESENT
	if [[ "$PASSPRESENT" == 0 ]]; then
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
		break
	elif [[ "$PASSPRESENT" == 1 ]]; then
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
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
while [[ true ]]; do
	echo -n "${SETUP_ENABLE_PROSYSTEM}"
	read yn
	if [[ -z "$yn" ]]; then
		echo "[-] ${SETUP_INVALID_INPUT}"
	elif [[ "$yn" == "YES" ]] || [[ "$yn" == "Yes" ]] || [[ "$yn" == "yes" ]]; then
		mkdir -p "$NVRAM/security"
		echo "Pro System" > "$NVRAM/security/prosys"
		echo "Unlocked" > "$NVRAM/security/lockstate"
		break
	elif [[ "$yn" == "NO" ]] || [[ "$yn" == "No" ]] || [[ "$yn" == "no" ]]; then
		mkdir -p "$NVRAM/security"
		echo "Default" > "$NVRAM/security/prosys"
		echo "Locked" > "$NVRAM/security/lockstate"
		break
	else
		echo "[-] ${SETUP_INVALID_INPUT}"
	fi
done
if [[ "$PROSYS" == 1 ]] && [[ "$PASSPRESENT" == "1" ]]; then
	while [[ true ]]; do
		echo -n "${SETUP_ENABLE_AUTOLOGIN}"
		read AUTOLOGIN
		if [[ "$AUTOLOGIN" == "YES" ]] || [[ "$AUTOLOGIN" == "Yes" ]] || [[ "$AUTOLOGIN" == "yes" ]]; then
			mkdir -p "$NVRAM/security"
			echo "system" > "$NVRAM/security/autologin"
			break
		elif [[ "$AUTOLOGIN" == "NO" ]] || [[ "$AUTOLOGIN" == "No" ]] || [[ "$AUTOLOGIN" == "no" ]]; then
			mkdir -p "$NVRAM/security"
			echo "" > "$NVRAM/security/autologin"
			break
		else
			echo "[-] ${SETUP_INVALID_INPUT}"
		fi
	done
fi
"$BundlePath/code/writer"