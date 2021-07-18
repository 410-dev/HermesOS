#!/bin/bash

if [[ "$HUID" -ne 0 ]]; then
	echo "${PERMISSION_DENIED}$HUID"
	exit 0
fi

if [[ ! -z "$1" ]]; then
	if [[ -f "$USERDATA/$1" ]]; then
		if [[ "$(access_fs "$USERDATA/$1")" -ne 0 ]]; then
			echo "${OPERATION_NOT_PERMITTED}File Write"
			exit 99
		fi
		if [[ -z "$(cat "$USERDATA/$1" | grep "@PROG_RUNNABLE")" ]]; then
			echo "Program not recognizable: Unable to find @PROG_RUNNABLE"
			exit 9
		fi
		chmod +x "$USERDATA/$1"
		echo "$1 is now runnable."
	else
		echo "${NO_SUCH_FILE}$1"
		exit 9
	fi
else
	echo "${MISSING_PARAM}Program path"
	exit 9
fi