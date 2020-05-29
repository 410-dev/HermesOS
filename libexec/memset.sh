#!/bin/bash
if [[ "$1" == F0x* ]]; then
	export memaddr="$1"
	if [[ "${#memaddr}" == 11 ]]; then
		if [[ ! -z "$2" ]]; then
			echo "Setting memory: $1=$2"
			mkdir -p "$CACHE/tmp/$(<$CACHE/SIG/swap_address)"
			echo "$2" > "$CACHE/tmp/$(<$CACHE/SIG/swap_address)/$1"
			exit 0
		else
			echo "Memory value is empty!"
			exit 1
		fi
	else
		echo "Invalid length of memory address!"
		exit 3
	fi
else
	echo "Memory address is not specified!"
	exit 2
fi