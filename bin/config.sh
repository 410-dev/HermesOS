#!/bin/bash
if [[ "$HUID" -ne 0 ]]; then
	echo "${PERMISSION_DENIED} $HUID"
	exit 0
fi

if [[ -z "$1" ]]; then
	echo "${NOT_ENOUGH_ARGS}"
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
		echo "${NOT_ENOUGH_ARGS}"
		exit 0
	fi
	if [[ ! -z "$(echo $2 | grep security/)" ]]; then
		echo "${OPERATION_NOT_PERMITTED}Editing security data in NVRAM is not permitted."
		exit 9
	else
		echo "$3 $4 $5 $6 $7 $8 $9" > "$NVRAM/$2"
	fi
elif [[ "$1" == "--username" ]]; then
	if [[ -z "$2" ]]; then
		echo "${ERROR}New username is not specified."
		exit 0
	fi
	regwrite "USER/UserName" "$2" >/dev/null
elif [[ "$1" == "--machinename" ]]; then
	if [[ -z "$2" ]]; then
		echo "${ERROR}New machine name is not specified."
		exit 0
	fi
	regwrite "MACHINE/MachineName" "$2" >/dev/null
elif [[ "$1" == "--password" ]]; then
	if [[ "$(regread USER/Security/LoginPasswordEnabled)" == "1" ]]; then
		echo -n "Old Password: "
		read -s pw
		echo ""
		if [[ "$(regread USER/Security/LoginPassword)" == "$(md5 -qs "$pw")" ]]; then
			echo -n "New Password: "
			read -s pw1
			echo ""
			echo -n "Retype New Password: "
			read -s pw2
			echo ""
			if [[ "$pw1" == "$pw2" ]]; then
				if [[ -z "$pw1" ]]; then
					regwrite "USER/Security/LoginPasswordEnabled" "0" >/dev/null
				fi
				regwrite "USER/Security/LoginPassword" "$(md5 -qs "$pw1")" >/dev/null
				echo "${DONE}"
			else
				echo "${ERROR}Password does not match."
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
			regwrite "USER/Security/LoginPassword" "$(md5 -qs "$pw1")" >/dev/null
			regwrite "USER/Security/LoginPasswordEnabled" "1" >/dev/null
			echo "${DONE}"
		else
			echo "${ERROR}Password does not match."
		fi
	fi
elif [[ "$1" == "--language" ]]; then
	if [[ -z "$2" ]]; then
		echo "You are currently using: ${LANG_ID}"
		echo ""
		echo "Available languages:"
		ls -1 "$OSSERVICES/Default/Languages"
	else
		if [[ -f "$OSSERVICES/Default/Languages/$2" ]]; then
			echo "Setting language..."
			cp "$OSSERVICES/Default/Languages/en-us/"* "$LIBRARY/Preferences/Language/"
			source "$LIBRARY/Preferences/Language/system.hlang"
			echo "${LANGUAGE_CHANGED}"
		else
			echo "No such language found."
		fi
	fi
else
	echo "Unknown action."
fi