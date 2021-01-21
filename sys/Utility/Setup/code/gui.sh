#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Starting graphical setup..."

"$BundlePath/code/langset_gui"
source "$LIBRARY/Preferences/Language/system.hlang"
while [[ true ]]; do
	export USRNAME="$("$SYSTEM/sys/Library/display" --stdout --inputbox "${SETUP_ASK_NAME}" 0 0)"
	if [[ -z "$USRNAME" ]]; then
		echo "${SETUP_INVALID_INPUT}"
	else
		mplxw "USER/user_name" "$USRNAME" >/dev/null
		break
	fi
done
while [[ true ]]; do
	export DEVN="$("$SYSTEM/sys/Library/display" --stdout --inputbox "${SETUP_ASK_DEVNAME}" 0 0)"
	if [[ -z "$DEVN" ]]; then
		echo "${SETUP_INVALID_INPUT}"
	else
		mplxw "SYSTEM/machine_name" "$DEVN" >/dev/null
		break
	fi
done
"$SYSTEM/sys/Library/display" --title "${SETUP}" --yesno "${SETUP_ASK_PASSBOOL}" 0 0
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
"$SYSTEM/sys/Library/display" --title "${SETUP}" --yesno "${SETUP_ENABLE_PROSYSTEM}" 0 0
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
	"$SYSTEM/sys/Library/display" --title "${SETUP}" --yesno "${SETUP_ENABLE_AUTOLOGIN}" 0 0
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