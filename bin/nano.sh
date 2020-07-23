#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing argument: File name"
	exit 9
fi
if [[ "$(accessible "w" "$USERDATA/$1")" == -9 ]]; then
	echo "Access denied: Operation not permitted."
	exit 99
else
	nano "$USERDATA/$1"
	exit $?
fi