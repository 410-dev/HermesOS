#!/bin/bash
if [[ "$USERLV" == "0" ]]; then
	exit 0
else
	source "$(dirname "$0")/access_directories.apd"
	echo "$ACCESS_ROOT_PERMISSION" | while read line
	do
		if [[ ! -z "$(echo "$1" | grep line)" ]]; then
			"$SYSTEMSUPPORT/Utility/Authenticate" "$lastExecutedCommand" "storage that requires higher privilage" "rootlevel"
			exit $?
		fi
	done

	ls -1 "$NVRAM/security/saved_userlevel_fileaccess/" | while read line
	do
		if [[ "$line" == "$lastExecutedCommand" ]]; then
			exit 0
		fi
	done

	echo "$ACCESS_USER_PERMISSION" | while read line
	do
		if [[ ! -z "$(echo "$1" | grep line)" ]]; then
			"$SYSTEMSUPPORT/Utility/Authenticate" "$lastExecutedCommand" "personal data" "userlevel"
			export exitc=$?
			if [[ "$exitc" == "0" ]]; then
				touch "$NVRAM/security/saved_userlevel_fileaccess/$lastExecutedCommand"
			fi
			exit $exitc
		fi
	done
	exit 1
fi