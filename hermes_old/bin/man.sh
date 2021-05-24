#!/bin/bash
if [[ -z "$1" ]]; then
	echo "${MISSING_PARAM}command"
	exit 90
fi
if [[ -f "$SYSTEM/man/$1" ]]; then
	cat "$SYSTEM/man/$1"
elif [[ "$(mplxr USER/INTERFACE/DEVELOPER_OPTION)" == "1" ]]; then
	if [[ -f "$OSSERVICES/Library/Developer/man/$1" ]]; then
		cat "$OSSERVICES/Library/Developer/man/$1"
	else
		echo "No manual available."
	fi
else
	echo "No manual available."
fi
exit 0