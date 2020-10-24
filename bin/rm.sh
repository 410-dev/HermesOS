#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing parameter."
	exit 90
fi
if [[ ! -e "$USERDATA/$1" ]]; then
	echo "No such file: $1"
	exit 91
fi
if [[ "$(accessible "w" "$USERDATA/$1")" -ne 0 ]]; then
	echo "Access denied: Operation not permitted."
	exit 99
fi
rm -rf "$USERDATA/$1"
exit $?