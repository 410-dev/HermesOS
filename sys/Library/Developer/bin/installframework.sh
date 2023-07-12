#!/bin/bash
if [[ "$(regread "USER/System/Legacy/EnableLegacyISA")" -ne "1" ]]; then
	echo "Legacy ISA is not enabled."
	exit 0
fi

if [[ -z "$1" ]]; then
	echo "Missing parameter: framework file"
	exit
fi
if [[ -f "$USERDATA/$1" ]]; then
	cp "$USERDATA/$1" "$LIBRARY/Developer/Frameworks/"
else
	echo "${NO_SUCH_FILE}$1"
	exit
fi