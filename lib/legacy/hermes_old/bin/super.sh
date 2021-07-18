#!/bin/bash

"$OSSERVICES/Utility/Authenticator"
if [[ "$?" == 0 ]]; then
	declare -i HUID
	export HUID="0"
	if [[ -f "$SYSTEM/bin/$1" ]]; then
		"$SYSTEM/bin/$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
	else
		echo "super: $1: command not found."
	fi
fi
export HUID="1"