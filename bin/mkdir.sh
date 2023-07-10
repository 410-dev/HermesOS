#!/bin/bash
if [[ -z "$1" ]]; then
	echo "${MISSING_PARAM}Directory Name"
	exit 90
fi
if [[ "$(access_fs "$PWD/$1")" -ne 0 ]]; then
	echo "${OPERATION_NOT_PERMITTED}Directory Write"
	exit 99
fi
mkdir -p "$PWD/$1"
exit $?