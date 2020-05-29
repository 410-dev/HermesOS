#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing parameter."
	exit 90
fi
if [[ "$1" == *..* ]]; then
	echo "Access denied: Operation not permitted."
	exit 99
fi
mkdir -p "$USERDATA/$1"
exit $?