#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing parameter."
	exit 90
fi
if [[ ! -f "$USERDATA/$1" ]]; then
	echo "No such file: $1"
	exit 91
fi
if [[ "$(accessible "r" "$USERDATA/$1")" == -9 ]]; then
	echo "Access denied: Operation not permitted."
	exit 99
fi
cat "$USERDATA/$1"
exit $?