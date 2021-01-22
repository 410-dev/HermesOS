#!/bin/bash
if [[ $(bootArgumentHas "recovery") == 1 ]]; then
	mkdir -p "$RECOVERY"
	echo "Entering recovery..."
	cp -r "$OSSERVICES/Library/RecoveryOS/"* "$RECOVERY"
	"$RECOVERY/BOOT"
	leaveSystem
	exit 0
elif [[ ! -d "$CORE" ]]; then
	mkdir -p "$RECOVERY"
	echo "Entering recovery..."
	cp -r "$OSSERVICES/Library/RecoveryOS/"* "$RECOVERY"
	"$RECOVERY/BOOT"
	leaveSystem
	exit 0
elif [[ ! -d "$NVRAM/enterrecovery" ]]; then
	mkdir -p "$RECOVERY"
	echo "Entering recovery..."
	cp -r "$OSSERVICES/Library/RecoveryOS/"* "$RECOVERY"
	"$RECOVERY/BOOT"
	leaveSystem
	exit 0
elif [[ ! -d "$OSSERVICES" ]]; then
	echo "Unable to start system."
fi
