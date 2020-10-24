#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing parameter."
	exit 90
fi
if [[ "$(accessible "w" "$USERDATA/$1")" -ne 0 ]]; then
	echo "Access denied: Operation not permitted."
	exit 99
fi
mkdir -p "$USERDATA/$1"
exit $?