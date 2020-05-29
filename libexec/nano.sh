#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing argument: File name"
	exit 9
else
	nano "$USERDATA/$1"
	exit $?
fi