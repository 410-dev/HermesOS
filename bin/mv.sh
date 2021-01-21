#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing parameter: Original file location"
	exit 90
fi
if [[ -z "$2" ]]; then
	echo "Missing parameter: New file location"
	exit 90
fi
if [[ ! -e "$USERDATA/$1" ]]; then
	echo "No such file: $1"
	exit 91
fi
if [[ "$(access_fs "$USERDATA/$1")" -ne 0 ]]; then
	echo "Access denied: Operation not permitted."
	exit 99
fi
if [[ "$(access_fs "$USERDATA/$2")" == -9 ]]; then
	echo "Access denied: Operation not permitted."
	exit 99
fi
mv "$USERDATA/$1" "$USERDATA/$2"
exit $?