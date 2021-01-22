#!/bin/bash
if [[ -z "$1" ]]; then
	echo "${MISSING_PARAM}File Name"
	exit 90
fi
if [[ ! -f "$USERDATA/$1" ]]; then
	echo "${NO_SUCH_FILE}$1"
	exit 91
fi
if [[ "$(access_fs "$USERDATA/$1")" == -9 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Read"
	exit 99
fi
cat "$USERDATA/$1"
exit $?