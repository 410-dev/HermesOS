#!/bin/bash
if [[ "$1" == "--set-key" ]]; then
	if [[ "$2" == "1" ]]; then
		echo "Pro System" > "$NVRAM/security/prosys"
	else
		echo "Default" > "$NVRAM/security/prosys"
	fi
else
	echo "Unknown Action."
fi