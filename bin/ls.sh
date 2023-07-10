#!/bin/bash
if [[ "$(access_fs "$PWD/$1")" == -9 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Read"
	exit 99
fi

ls -1 "$PWD/$1"
