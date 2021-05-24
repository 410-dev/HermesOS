#!/bin/bash
if [[ "$1" == "--set-key" ]]; then
	if [[ "$2" == "1" ]]; then
		echo "Pro System" > "$NVRAM/security/prosys"
		echo "Unlocked" > "$NVRAM/security/lockstate"
	else
		echo "Default" > "$NVRAM/security/prosys"
		echo "Locked" > "$NVRAM/security/lockstate"
	fi
else
	echo "Unknown Action."
fi