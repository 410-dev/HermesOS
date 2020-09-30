#!/bin/bash

echo "Process \"$1\" is trying to access $2. Would you allow this? (Y/n)"
read in
if [[ "$in" == "y" ]] || [[ "$in" == "Y" ]]; then
	if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "nothing" ]] || [[ "$(mplxr USER/SECURITY/PASSCODE_PRESENT)" == "0" ]]; then
		exit 0
	elif [[ "$3" == "userlevel" ]]; then
		exit 0
	else
		for (( i = 0; i < 3; i++ )); do
			echo -n "Please enter your password: "
			read -s PASS
			echo ""
			if [[ "$(mplxr USER/SECURITY/PASSCODE)" == "$(md5 -qs $PASS)" ]]; then
				exit 0
			else
				echo "Error: Password does not match."
			fi
		done
		echo "Sorry, you have entered wrong password too many times."
		exit 1
	fi
elif [[ "$in" == "n" ]] || [[ "$in" == "N" ]]; then
	exit 1
else
	echo "Unknown input. Interpreted as decline."
	exit 1
fi


