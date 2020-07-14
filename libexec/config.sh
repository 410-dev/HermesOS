#!/bin/bash

if [[ "$1" == "--nvram" ]]; then
	if [[ -z "$2" ]] || [[ -z "$3" ]]; then
		echo "Error: Not enough arguments."
		exit 0
	fi
	echo "$3" > "$NVRAM/$2"
elif [[ "$1" == "--username" ]]; then
	if [[ -z "$2" ]]; then
		echo "Error: New username is not specified."
		exit 0
	fi
	mplxw "USER/user_name" "$2"
elif [[ "$1" == "--machinename" ]]; then
	if [[ -z "$2" ]]; then
		echo "Error: New machine name is not specified."
		exit 0
	fi
	mplxw "SYSTEM/machine_name" "$2"
elif [[ "$1" == "--password" ]]; then
	if [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "1" ]]; then
		echo -n "Old Password: "
		read pw
		if [[ "$(mplxr USER/SECURITY/PASSCODE)" -ne "pw" ]]; then
			echo "Wrong password!"
			exit 0
		else
			echo -n "New Password: "
			read pw
			if [[ -z "$pw" ]]; then
				mplxw "USER/SECURITY/PASSCODE_PRESENT" "0"
			fi
			mplxw "USER/SECURITY/PASSCODE" "$pw"
			echo "Done."
		fi
	else
		echo -n "New Password: "
		read pw
		mplxw "USER/SECURITY/PASSCODE" "$pw"
		mplxw "USER/SECURITY/PASSCODE_PRESENT" "1"
		echo "Done."
	fi
else
	echo "Unknown action."
fi