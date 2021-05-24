#!/bin/bash
if [[ $(bootArgumentHas "recovery") == 1 ]]; then
	mkdir -p "$RECOVERY"
	sys_log "recovery-init" "Entering recovery: Boot argument"
	echo "Entering recovery..."
	cp -r "$OSSERVICES/Library/RecoveryOS/"* "$RECOVERY"
	"$RECOVERY/BOOT"
	leaveSystem
	exit 0
elif [[ ! -d "$CORE" ]]; then
	mkdir -p "$RECOVERY"
	sys_log "recovery-init" "Entering recovery: Missing core"
	echo "Entering recovery..."
	cp -r "$OSSERVICES/Library/RecoveryOS/"* "$RECOVERY"
	"$RECOVERY/BOOT"
	leaveSystem
	exit 0
elif [[ -f "$NVRAM/enterrecovery" ]]; then
	mkdir -p "$RECOVERY"
	sys_log "recovery-init" "Entering recovery: enterrecovery present"
	echo "Entering recovery..."
	cp -r "$OSSERVICES/Library/RecoveryOS/"* "$RECOVERY"
	"$RECOVERY/BOOT"
	leaveSystem
	exit 0
elif [[ ! -d "$OSSERVICES" ]]; then
	sys_log "recovery-init" "Unable to enter recovery: No recovery included"
	echo "Unable to start system."
fi
