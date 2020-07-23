#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Missing parameter: command"
	exit 90
fi
if [[ -f "$SYSTEM/man/$1" ]]; then
	cat "$SYSTEM/man/$1"
else
	echo "No manual available."
fi
exit 0