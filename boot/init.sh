#!/bin/bash
source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/internal_func"

sys_log "boot" "System run signal received."

if [[ -f "$NVRAM/boot_reference" ]]; then
	sys_log "boot" "Boot reference found. Reading..."
	cp "$NVRAM/boot_reference" "$CACHE/bootconf"
	chmod +x "$CACHE/bootconf"
	source "$CACHE/bootconf"
	rm -f "$CACHE/bootconf"
fi

if [[ -f "$BOOTREFUSE" ]]; then
	sys_log "boot" "There was boot refuse flag."
	rm -f "$BOOTREFUSE"
	sys_log "boot" "Flag removed."
fi


export BOOTARGS="$1 $2 $3 $4 $5 $6 $7 $8 $9"
if [[ -f "$NVRAM/boot-arguments" ]]; then
	export BOOTARGS="$BOOTARGS $(<"$NVRAM/boot-arguments")"
fi
sys_log "boot" "Boot arguments: $BOOTARGS"

"$(dirname "$0")/recovery"
sys_log "boot" "Did not enter recovery."

while [[ $(bootArgumentHas "recovery") == 0 ]]; do
	sys_log "boot" "Starting Hermes..."
	verbose "[${GREEN}*${C_DEFAULT}] Starting Hermes..."
	if [[ -f "$CORE/loader" ]]; then
		sys_log "boot" "Reading loader..."
		source "$CORE/loader"
		export endcode=$?
		if [[ -f "$BOOTREFUSE" ]]; then
			sys_log "boot" "Boot refused."
			echo -e "[${RED}-${C_DEFAULT}] Ending System."
			leaveSystem
		elif [[ $endcode -ne 0 ]]; then
			sys_log "boot" "System exception: ${endcode}"
			"$CORE/error" "${RED}Core.osstart terminated with unexpected return code: ${endcode}${C_DEFAULT}"
			exit 0
		fi
	else
		sys_log "boot" "Unable to load core."
		"$CORE/error" "${RED}Unable to load core. Aborting boot procedure.${C_DEFAULT}"
		exit 0
	fi
	sys_log "boot" "Starting UI..."
	"$CORE/uistart"
	if [[ "$?" == 0 ]]; then
		sys_log "boot" "Shutdown signal received..."
		break
	fi
done
leaveSystem