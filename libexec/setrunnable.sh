#!/bin/bash
if [[ ! -z "$1" ]]; then
	if [[ -f "$USERDATA/$1" ]]; then
		chmod +x "$USERDATA/$1"
		echo "$1 is now runnable."
	else
		echo "File not found."
		exit 9
	fi
else
	echo "Missing argument: program path"
	exit 9
fi