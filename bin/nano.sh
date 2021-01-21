#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing argument: File name"
	exit 9
fi
if [[ "$(access_fs "$USERDATA/$1")" -ne 0 ]]; then
	echo "Access denied: Operation not permitted."
	exit 99
else
	nano "$USERDATA/$1"
	exit $?
fi