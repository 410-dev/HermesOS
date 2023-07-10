#!/bin/bash

"$OSSERVICES/Utility/Authenticator"
if [[ "$?" == 0 ]]; then
	declare -i HUID
	export HUID="0"
	if [[ -f "$SYSTEM/bin/$1" ]]; then
		COMMAND="$SYSTEM/bin/$1"
		shift
		"$COMMAND" "$@"
	elif [[ "$(regread USER/Shell/DeveloperOptions)" == "1" ]]; then
		if [[ -f "$OSSERVICES/Library/Developer/man/$1" ]]; then
			COMMAND="$OSSERVICES/Library/Developer/bin/$1"
			shift
			"$COMMAND" "$@"
		else
			echo "sudo: $1: command not found."
		fi
	else
		echo "sudo: $1: command not found."
	fi
fi
export HUID="1"