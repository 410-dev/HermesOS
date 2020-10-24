#!/bin/bash

if [[ "$HUID" -ne 0 ]]; then
	echo "Permission denied: $HUID"
	exit 0
fi

if [[ ! -z "$1" ]]; then
	if [[ -f "$USERDATA/$1" ]]; then
		if [[ "$(accessible "w" "$USERDATA/$1")" -ne 0 ]]; then
			echo "Access denied: Operation not permitted."
			exit 99
		fi
		if [[ -z "$(cat "$USERDATA/$1" | grep "@PROG_RUNNABLE")" ]]; then
			echo "Program not recognizable: Unable to find @PROG_RUNNABLE"
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