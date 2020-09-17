#!/bin/bash

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
elif [[ "$1" == "--machinename" ]]; then
	if [[ -z "$2" ]]; then
		echo "Error: New machine name is not specified."
		exit 0
	fi
	mplxw "SYSTEM/machine_name" "$2" >/dev/null
elif [[ "$1" == "--password" ]]; then
	if [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "1" ]]; then
		echo -n "Old Password: "
		read pw
		if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs "$pw")" ]]; then
			echo -n "New Password: "
			read pw
			if [[ -z "$pw" ]]; then
				mplxw "USER/SECURITY/PASSCODE_PRESENT" "0" >/dev/null
			fi
			mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs "$pw")" >/dev/null
			echo "Done."
		else
			echo "Wrong password!"
			exit 0
		fi
	else
		echo -n "New Password: "
		read pw
		mplxw "USER/SECURITY/PASSCODE" "$(md5 -qs "$pw")" >/dev/null
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "1" >/dev/null
		echo "Done."
	fi
else
	echo "Unknown action."
fi