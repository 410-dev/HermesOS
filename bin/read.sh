#!/bin/bash
if [[ -z "$1" ]]; then
	echo "${MISSING_PARAM}File Name"
	exit 90
fi
if [[ ! -f "$PWD/$1" ]]; then
	echo "${NO_SUCH_FILE}$1"
	exit 91
fi
if [[ "$(access_fs "$PWD/$1")" == -9 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Read"
	exit 99
fi
cat "$PWD/$1"
exit $?