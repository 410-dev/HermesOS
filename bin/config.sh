#!/bin/bash
if [[ "$HUID" -ne 0 ]]; then
	echo "Permission denied: $HUID"
	exit 0
fi

if [[ "$1" == "--nvram" ]]; then
	if [[ -z "$2" ]] || [[ -z "$3" ]]; then
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
else
	echo "Unknown action."
fi