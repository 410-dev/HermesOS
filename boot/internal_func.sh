#!/bin/bash
function syslog() {
	echo "$(date '+%Y %m %d %H:%M:%S') [ $1 ] $2" >> "$LIBRARY/Logs/$LOGFILENAME"
}

function bootArgumentHas() {
	if [[ ! -z "$(echo "$BOOTARGS" | grep "$1")" ]]; then
		syslog "internal-func" "Boot argument contains $1."
		echo 1
	else
		syslog "internal-func" "Boot argument does not contain $1."
		echo 0
	fi
}

function verbose() {
	if [[ $(bootArgumentHas "verbose") == 1 ]]; then
		echo -e "$1"
	fi
}

function leaveSystem() {
	syslog "internal-func" "Leaving system..."
	if [[ $(bootArgumentHas "no-cache-reset") == 0 ]]; then
		rm -rf "$CACHE" 2>/dev/null
	fi
	exit 0
}

export -f bootArgumentHas
export -f verbose
export -f leaveSystem
export -f syslog
export LOGFILENAME="$(date '+%Y%m%d%H%M%S')"
