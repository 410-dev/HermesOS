#!/bin/bash

if [[ "$HUID" -ne 0 ]]; then
	echo "${PERMISSION_DENIED}$HUID"
	exit 0
fi

if [[ ! -z "$1" ]]; then
	if [[ -f "$PWD/$1" ]]; then
		if [[ "$(access_fs "$PWD/$1")" -ne 0 ]]; then
			echo "${OPERATION_NOT_PERMITTED}File Write"
			exit 99
		fi
		chmod +x "$PWD/$1"
		echo "$1 is now runnable."
	else
		echo "${NO_SUCH_FILE}$1"
		exit 9
	fi
else
	echo "${MISSING_PARAM}Program path"
	exit 9
fi