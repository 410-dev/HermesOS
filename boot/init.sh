#!/bin/bash
source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/instructions.hdp"

if [[ -f "$NVRAM/boot_argument" ]]; then
	export BOOTARGS="$BOOTARGS $(<"$NVRAM/boot_argument")"
fi
if [[ -f "$NVRAM/boot_reference" ]]; then
	cp "$NVRAM/boot_reference" "$CACHE/bootconf"
	chmod +x "$CACHE/bootconf"
	source "$CACHE/bootconf"
	rm -f "$CACHE/bootconf"
fi

if [[ -f "$BOOTREFUSE" ]]; then
	rm -f "$BOOTREFUSE"
fi

export BOOTARGS="$BOOTARGS $1 $2 $3 $4 $5 $6 $7 $8 $9"

while [[ true ]]; do
	verbose "[*] Starting Hermes..."
	if [[ -f "$CORE/core" ]]; then
		"$CORE/core" "osstart"
		export endcode=$?
		if [[ -f "$BOOTREFUSE" ]]; then
			echo "[-] Ending System."
			leaveSystem
		elif [[ $endcode -ne 0 ]]; then
			"$CORE/core" "error" "Core.osstart terminated with unexpected return code: $endcode"
			exit 0
		fi
	else
		"$CORE/core" "error" "Unable to load core. Aborting boot procedure."
		exit 0
	fi
	"$CORE/rmleak"
	"$CORE/core" "uistart"
	if [[ "$?" == 0 ]]; then
		break
	fi
done
leaveSystem