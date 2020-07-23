#!/bin/bash
if [[ ! -z "$1" ]]; then
	if [[ -f "$USERDATA/$1" ]]; then
		if [[ "$(accessible "w" "$USERDATA/$1")" == -9 ]]; then
			echo "Access denied: Operation not permitted."
			exit 99
		fi
		if [[ -z "$(cat "$USERDATA/$1" | grep "@PROG_START_POINT")" ]]; then
			echo "Program not recognizable: Unable to find @PROG_START_POINT"
			exit 9
		fi
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