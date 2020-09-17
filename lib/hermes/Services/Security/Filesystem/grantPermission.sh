#!/bin/bash

# lastExecutedCommand is the process name.
# USERLV gets user permission
# $1 is real path

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

	echo "$ACCESS_USER_PERMISSION" | while read line
	do
		if [[ ! -z "$(echo "$1" | grep line)" ]]; then
			"$SYSTEMSUPPORT/Utility/Authenticate" "$lastExecutedCommand" "user's data" "userlevel"
			exit $?
		fi
	done

	echo "$ACCESS_EXTERNAL_DRIVE" | while read line
	do
		if [[ ! -z "$(echo "$1" | grep line)" ]]; then
			"$SYSTEMSUPPORT/Utility/Authenticate" "$lastExecutedCommand" "external storage" "userlevel"
			exit $?
		fi
	done
	exit 1
fi