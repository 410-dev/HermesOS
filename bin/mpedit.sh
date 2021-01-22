#!/bin/bash
# setkey [key name]
# setvalue [value name] [value]
# delete [key or value name]
# read [key or value name]
if [[ "$HUID" -ne 0 ]]; then
	echo "${PERMISSION_DENIED}$HUID"
	exit 0
fi

if [[ "$(access_fs "$MULTIPLEX/$2")" == "-9" ]]; then
	echo "${ERROR}Modifying data not within multiplex is not permitted."
	exit -9
fi

if [[ "$1" == "setkey" ]]; then
	if [[ -z "$2" ]]; then
		echo "${ERROR}Key name is not specified."
		exit 0
	fi
	if [[ -e "$MULTIPLEX/$2" ]]; then
		if [[ -d "$MULTIPLEX/$2" ]]; then
			echo "The key already exists."
			exit 0
		else
			echo "There is a value with the same name."
			exit 0
		fi
	else
		mkdir -p "$MULTIPLEX/$2"
	fi
elif [[ "$1" == "setvalue" ]]; then
	if [[ -z "$2" ]]; then
		echo "${ERROR}Value name is not specified."
		exit 0
	fi
	if [[ -z "$3" ]]; then
		echo "${ERROR}value is not specified."
		exit 0
	fi
	if [[ -d "$MULTIPLEX/$2" ]]; then
		echo "There is a key with the same name."
		exit 0
	else
		echo "$3" > "$MULTIPLEX/$2"
	fi
elif [[ "$1" == "delete" ]]; then
	if [[ -z "$2" ]]; then
		echo "${ERROR}Key name is not specified."
		exit 0
	fi
	if [[ -e "$MULTIPLEX/$2" ]]; then
		rm -rf "$MULTIPLEX/$2"
	else
		echo "There is no such key or value."
	fi
elif [[ "$1" == "read" ]]; then
	if [[ -z "$2" ]]; then
		echo "${ERROR}Value or key name is not specified."
		exit 0
	fi
	if [[ -d "$MULTIPLEX/$2" ]]; then
		ls -1 "$MULTIPLEX/$2"
		exit 0
	else
		cat "$MULTIPLEX/$2"
		exit 0
	fi
else
	echo "Unknown action."
fi