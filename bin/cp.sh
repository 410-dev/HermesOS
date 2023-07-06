#!/bin/bash
if [[ -z "$1" ]]; then
	echo "${MISSING_PARAM}Original file location"
	exit 90
fi
if [[ -z "$2" ]]; then
	echo "${MISSING_PARAM}New file location"
	exit 90
fi
if [[ ! -e "$USERDATA/$1" ]]; then
	echo "${NO_SUCH_FILE}$1"
	exit 91
fi
if [[ "$(access_fs "$USERDATA/$1")" == -9 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Read"
	exit 99
fi
if [[ "$(access_fs "$USERDATA/$2")" == -9 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Write"
	exit 99
fi
cp -r "$USERDATA/$1" "$USERDATA/$2"
exit $?