#!/bin/bash
source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/internal_func"

syslog "boot" "System run signal received."

if [[ -f "$NVRAM/boot_reference" ]]; then
	syslog "boot" "Boot reference found. Reading..."
	cp "$NVRAM/boot_reference" "$CACHE/bootconf"
	chmod +x "$CACHE/bootconf"
	source "$CACHE/bootconf"
	rm -f "$CACHE/bootconf"
fi

if [[ -f "$BOOTREFUSE" ]]; then
	syslog "boot" "There was boot refuse flag."
	rm -f "$BOOTREFUSE"
	syslog "boot" "Flag removed."
fi


export BOOTARGS="$1 $2 $3 $4 $5 $6 $7 $8 $9"
if [[ -f "$NVRAM/boot-arguments" ]]; then
	export BOOTARGS="$BOOTARGS $(<"$NVRAM/boot-arguments")"
fi
syslog "boot" "Boot arguments: $BOOTARGS"

"$(dirname "$0")/recovery"
syslog "boot" "Did not enter recovery."

while [[ $(bootArgumentHas "recovery") == 0 ]]; do
	syslog "boot" "Starting Hermes..."
	verbose "[${GREEN}*${C_DEFAULT}] Starting Hermes..."
	if [[ -f "$CORE/loader" ]]; then
		syslog "boot" "Reading loader..."
		source "$CORE/loader"
		export endcode=$?
		if [[ -f "$BOOTREFUSE" ]]; then
			syslog "boot" "Boot refused."
			echo -e "[${RED}-${C_DEFAULT}] Ending System."
			leaveSystem
		elif [[ $endcode -ne 0 ]]; then
			syslog "boot" "System exception: ${endcode}"
			"$CORE/error" "${RED}Core.osstart terminated with unexpected return code: ${endcode}${C_DEFAULT}"
			exit 0
		fi
	else
		syslog "boot" "Unable to load core."
		"$CORE/error" "${RED}Unable to load core. Aborting boot procedure.${C_DEFAULT}"
		exit 0
	fi
	syslog "boot" "Starting UI..."
	"$CORE/uistart"
	if [[ "$?" == 0 ]]; then
		syslog "boot" "Shutdown signal received..."
		break
	fi
done
leaveSystem