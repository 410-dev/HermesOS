#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Starting non-graphical setup..."
ls -1 "$SYSTEM/sys/Default/Languages"
while [[ true ]]; do
	echo ""
	echo "To keep your current language, just press enter."
	echo -n "Choose your language: "
	read language
	if [[ -z "$language" ]]; then
		echo "You have selected: ${LANG_ID}"
	elif [[ -f "$SYSTEM/sys/Default/Languages/$language" ]]; then
		echo "${SETTING_LANGUAGE}"
		rm -rf "$LIBRARY/Preferences/Language/system.hlang"
		cp "$SYSTEM/sys/Default/Languages/$language" "$LIBRARY/Preferences/Language"
		mv "$LIBRARY/Preferences/Language/$language" "$LIBRARY/Preferences/Language/system.hlang"
		source "$LIBRARY/Preferences/Language/system.hlang"
		echo "${LANGUAGE_CHANGED_ON_SETUP}"
	else
		echo "No such language."
	fi
done
while [[ true ]]; do
	echo -n "What is your name? (English and Number only, no spacebar) : "
	read USRNAME
	if [[ -z "$USRNAME" ]]; then
		echo "[-] ${INVALID_INPUT}"
	else
		mplxw "USER/user_name" "$USRNAME" >/dev/null
		break
	fi
done
while [[ true ]]; do
	echo -n "What is your device name? (English and Number only, no spacebar) : "
	read DEVN
	if [[ -z "$DEVN" ]]; then
		echo "[-] ${INVALID_INPUT}"
	else
		mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
		break
	fi
done
while [[ true ]]; do
	echo -n "Would you use a passcode? 0 (No)/1 (Yes) : "
	read PASSPRESENT
	if [[ "$PASSPRESENT" == 0 ]]; then
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
		break
	elif [[ "$PASSPRESENT" == 1 ]]; then
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
		while [[ true ]]; do
			if [[ "$PASSPRESENT" == "1" ]]; then
				echo -n "What is your password? : "
				read -s PASS
				echo ""
				if [[ -z "$PASS" ]]; then
					echo "[-] ${INVALID_INPUT}"
				else
					mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs $PASS)" >/dev/null
					break
				fi
			fi
		done
		break
	else
		echo "[-] ${INVALID_INPUT}"
	fi
done
while [[ true ]]; do
	echo -n "Would you enable Pro System? (System protection will be disabled) yes / no: "
	read yn
	if [[ -z "$yn" ]]; then
		echo "[-] ${INVALID_INPUT}"
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
		echo "[-] ${INVALID_INPUT}"
	fi
done
if [[ "$PROSYS" == 1 ]] && [[ "$PASSPRESENT" == "1" ]]; then
	while [[ true ]]; do
		echo -n "Do you want to enable auto-login? yes / no"
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
			echo "[-] ${INVALID_INPUT}"
		fi
	done
fi
"$BundlePath/code/writer"