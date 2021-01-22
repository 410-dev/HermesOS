#!/bin/bash
function bootArgumentHas() {
	if [[ ! -z "$(echo "$BOOTARGS" | grep "$1")" ]]; then
		echo 1
	else
		echo 0
	fi
}

function verbose() {
	if [[ $(bootArgumentHas "verbose") == 1 ]]; then
		echo -e "$1"
	fi
}

function leaveSystem() {
	if [[ $(bootArgumentHas "no-cache-reset") == 0 ]]; then
		rm -rf "$CACHE" 2>/dev/null
		exit 0
	fi
	
}

function Log() {
	echo "$(date '+%Y %m %d %H:%M:%S') [ $1 ] $2" >> "$LIBRARY/Logs/$LOGFILENAME"
}

export -f bootArgumentHas
export -f verbose
export -f leaveSystem
export -f Log
export LOGFILENAME="$(date '+%Y%m%d%H%M%S')"
