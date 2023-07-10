#!/bin/bash
# setkey [key name]
# setvalue [value name] [value]
# delete [key or value name]
# read [key or value name]
if [[ "$HUID" -ne 0 ]]; then
	echo "${PERMISSION_DENIED}$HUID"
	exit 0
fi

if [[ "$(access_fs "$REGISTRY/$2")" == "-9" ]]; then
	echo "${ERROR}Modifying data not within registry is not permitted."
	exit -9
fi

if [[ "$1" == "setkey" ]]; then
	if [[ -z "$2" ]]; then
		echo "${ERROR}Key name is not specified."
		exit 0
	fi
	if [[ -e "$REGISTRY/$2" ]]; then
		if [[ -d "$REGISTRY/$2" ]]; then
			echo "The key already exists."
			exit 0
		else
			echo "There is a value with the same name."
			exit 0
		fi
	else
		mkdir -p "$REGISTRY/$2"
		echo "Key created: $2"
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
	if [[ -d "$REGISTRY/$2" ]]; then
		echo "There is a key with the same name."
		exit 0
	else
		REGLOC="$REGISTRY/$2"
		shift
		shift
		echo "$@" > "$REGLOC"
		echo "Value set: $@"
	fi
elif [[ "$1" == "delete" ]]; then
	if [[ -z "$2" ]]; then
		echo "${ERROR}Key name is not specified."
		exit 0
	fi
	if [[ -e "$REGISTRY/$2" ]]; then
		rm -rf "$REGISTRY/$2"
		echo "Key or value deleted: $2"
	else
		echo "There is no such key or value."
	fi
elif [[ "$1" == "read" ]]; then
	if [[ -z "$2" ]]; then
		echo "${ERROR}Value or key name is not specified."
		exit 0
	fi
	if [[ -d "$REGISTRY/$2" ]]; then
		ls -1 "$REGISTRY/$2"
		exit 0
	else
		cat "$REGISTRY/$2"
		exit 0
	fi
else
	echo "Unknown action."
fi