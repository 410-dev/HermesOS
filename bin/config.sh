#!/bin/bash
if [[ "$HUID" -ne 0 ]]; then
	echo "Permission denied: $HUID"
	exit 0
fi

if [[ -z "$1" ]]; then
	echo "Error: Not enough arguments."
	exit 0
elif [[ "$1" == "--nvram" ]]; then
	mkdir -p "$NVRAM"
	if [[ -z "$2" ]]; then
		ls -1 "$NVRAM" | while read conf
		do
			if [[ -f "$NVRAM/$conf" ]]; then
				echo "$conf        : $(cat "$NVRAM/$conf")"
			else
				echo "$conf - has multiple configurations"
			fi
		done
		exit 0
	fi
	if [[ -z "$3" ]]; then	
		echo "Error: Not enough arguments."
		exit 0
	fi
	if [[ ! -z "$(echo $2 | grep security/)" ]]; then
		echo "Operation not permitted: Editing security data in NVRAM is not permitted."
		exit 9
	else
		echo "$3 $4 $5 $6 $7 $8 $9" > "$NVRAM/$2"
	fi
elif [[ "$1" == "--username" ]]; then
	if [[ -z "$2" ]]; then
		echo "Error: New username is not specified."
		exit 0
	fi
	mplxw "USER/user_name" "$2" >/dev/null
elif [[ "$1" == "--fastboot" ]]; then
	if [[ -z "$2" ]]; then
		echo "Error: on / off is not specified."
		exit 0
	elif [[ "$2" == "on" ]]; then
		echo "Turning fastboot on..."
		mplxw "SYSTEM/POLICY/use_fastboot" "1" >/dev/null
	elif [[ "$2" == "off" ]]; then
		echo "Turning fastboot off..."
		mplxw "SYSTEM/POLICY/use_fastboot" "0" >/dev/null
	else
		echo "Unknown state: $2"
		echo "State must be either one: on / off"
		echo "Case sensitive."
	fi
elif [[ "$1" == "--machinename" ]]; then
	if [[ -z "$2" ]]; then
		echo "Error: New machine name is not specified."
		exit 0
	fi
	mplxw "SYSTEM/machine_name" "$2" >/dev/null
elif [[ "$1" == "--password" ]]; then
	if [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "1" ]]; then
		echo -n "Old Password: "
		read -s pw
		echo ""
		if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs "$pw")" ]]; then
			echo -n "New Password: "
			read -s pw1
			echo ""
			echo -n "Retype New Password: "
			read -s pw2
			echo ""
			if [[ "$pw1" == "$pw2" ]]; then
				if [[ -z "$pw1" ]]; then
					mplxw "USER/SECURITY/PASSCODE_PRESENT" "0" >/dev/null
				fi
				mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs "$pw1")" >/dev/null
				echo "Done."
			else
				echo "Error: Password does not match."
			fi
		else
			echo "Wrong password!"
			exit 0
		fi
	else
		echo -n "New Password: "
		read -s pw1
		echo ""
		echo -n "Retype New Password: "
		read -s pw2
		echo ""
		if [[ "$pw1" == "$pw2" ]]; then
			mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs "$pw1")" >/dev/null
			mplxw "USER/SECURITY/PASSCODE_PRESENT" "1" >/dev/null
			echo "Done."
		else
			echo "Error: Password does not match."
		fi
	fi
elif [[ "$1" == "--language" ]]; then
	if [[ -z "$2" ]]; then
		echo "You are currently using: ${LANG_ID}"
		echo ""
		echo "Available languages:"
		ls -1 "$SYSTEM/sys/Default/Languages"
	elif [[ $(bootArgumentHas "verbose") == "1" ]] || [[ $(bootArgumentHas "nogui") == "1" ]] || [[ $(bootArgumentHas "safe") == "1" ]]; then
		if [[ -f "$SYSTEM/sys/Default/Languages/$2" ]]; then
			echo "Setting language..."
			cp "$SYSTEM/sys/Default/Languages/en-us/"* "$LIBRARY/Preferences/Language/"
			source "$LIBRARY/Preferences/Language/system.hlang"
			echo "${LANGUAGE_CHANGED}"
		else
			echo "No such language found."
		fi
	else
		export BundlePath="$SYSTEM/sys/Utility/Setup"
		"$SYSTEM/sys/Utility/Setup/code/langset_gui"
	fi
else
	echo "Unknown action."
fi