#!/bin/bash
if [[ -z "$1" ]]; then
	echo "${MISSING_PARAM}File name"
	exit 9
fi
if [[ "$(access_fs "$PWD/$1")" -ne 0 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Write"
	exit 99
else
	nano "$PWD/$1"
	exit $?
fi