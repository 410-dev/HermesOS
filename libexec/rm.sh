#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing parameter."
	exit 90
fi
if [[ "$1" == *..* ]]; then
	echo "Access denied: Operation not permitted."
	exit 99
fi
if [[ ! -e "$USERDATA/$1" ]]; then
	echo "No such file: $1"
	exit 91
fi
rm -rf "$USERDATA/$1"
exit $?