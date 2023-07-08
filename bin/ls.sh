#!/bin/bash
if [[ "$(access_fs "$USERDATA/$1")" == -9 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Read"
	exit 99
fi
if [[ "$(access_fs "$USERDATA/$2")" == -9 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Write"
	exit 99
fi
ls -1 "$USERDATA/$1"