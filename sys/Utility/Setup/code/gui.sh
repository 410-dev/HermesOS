#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Starting graphical setup..."

source "$BundlePath/code/languages_selectable"
export language="$("$SYSTEM/sys/Library/display" --stdout --radiolist "Select Language" 0 0 0 $langd)"
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

while [[ true ]]; do
	export USRNAME="$("$SYSTEM/sys/Library/display" --stdout --inputbox "What is your name?" 0 0)"
	if [[ -z "$USRNAME" ]]; then
		echo "[-] Invalid input."
	else
		mplxw "USER/user_name" "$USRNAME" >/dev/null
		break
	fi
done
while [[ true ]]; do
	export DEVN="$("$SYSTEM/sys/Library/display" --stdout --inputbox "What is your device name?" 0 0)"
	if [[ -z "$DEVN" ]]; then
		echo "[-] Invalid input."
	else
		mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
		break
	fi
done
"$SYSTEM/sys/Library/display" --title "Setup" --yesno "Would you use a passcode?" 0 0
export PASSPRESENT=$?
if [[ "$PASSPRESENT" == "0" ]]; then
	export PASSPRESENT="1"
else
	export PASSPRESENT="0"
fi
mplxw "USER/SECURITY/PASSCODE_PRESENT" "$PASSPRESENT" >/dev/null
while [[ "$PASSPRESENT" == "1" ]]; do
	if [[ "$PASSPRESENT" == "1" ]]; then
		clear
		echo -n "What is your password?: "
		read -s PASS
		echo ""
		if [[ -z "$PASS" ]]; then
			echo "[-] Invalid input."
		else
			mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs $PASS)" >/dev/null
			break
		fi
	fi
done
"$SYSTEM/sys/Library/display" --title "Setup" --yesno "Do you want to enable Pro System? (System protection will be disabled)" 0 0
export PROSYS=$?
if [[ "$PROSYS" == "0" ]]; then
	export PROSYS="1"
else
	export PROSYS="0"
fi
if [[ "$PROSYS" == "1" ]]; then
	mkdir -p "$NVRAM/security"
	echo "Pro System" > "$NVRAM/security/prosys"
	echo "Unlocked" > "$NVRAM/security/lockstate"
elif [[ "$PROSYS" == "0" ]]; then
	mkdir -p "$NVRAM/security"
	echo "Default" > "$NVRAM/security/prosys"
	echo "Locked" > "$NVRAM/security/lockstate"
fi
if [[ "$PROSYS" == 1 ]] && [[ "$PASSPRESENT" == "1" ]]; then
	"$SYSTEM/sys/Library/display" --title "Setup" --yesno "Do you want to enable auto-login?" 0 0
	export AUTOLOGIN=$?
	if [[ "$AUTOLOGIN" == "0" ]]; then
		export AUTOLOGIN="1"
	else
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