#!/bin/bash
if [[ -z "$1" ]]; then
	echo "${MISSING_PARAM}Original file location"
	exit 90
fi
if [[ -z "$2" ]]; then
	echo "${MISSING_PARAM}New file location"
	exit 90
fi
if [[ ! -e "$PWD/$1" ]]; then
	echo "${NO_SUCH_FILE}$1"
	exit 91
fi
if [[ "$(access_fs "$PWD/$1")" -ne 0 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Read"
	exit 99
fi
if [[ "$(access_fs "$PWD/$2")" == -9 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Write"
	exit 99
fi
mv "$PWD/$1" "$PWD/$2"
exit $?