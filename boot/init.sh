#!/bin/bash
source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/internal_func"

if [[ -f "$NVRAM/boot_reference" ]]; then
	cp "$NVRAM/boot_reference" "$CACHE/bootconf"
	chmod +x "$CACHE/bootconf"
	source "$CACHE/bootconf"
	rm -f "$CACHE/bootconf"
fi

if [[ -f "$BOOTREFUSE" ]]; then
	rm -f "$BOOTREFUSE"
fi


export BOOTARGS="$1 $2 $3 $4 $5 $6 $7 $8 $9"
if [[ -f "$NVRAM/boot-arguments" ]]; then
	export BOOTARGS="$BOOTARGS $(<"$NVRAM/boot-arguments")"
fi

"$(dirname "$0")/recovery"

while [[ $(bootArgumentHas "recovery") == 0 ]]; do
	verbose "[${GREEN}*${C_DEFAULT}] Starting Hermes..."
	if [[ -f "$CORE/loader" ]]; then
		source "$CORE/loader"
		export endcode=$?
		if [[ -f "$BOOTREFUSE" ]]; then
			echo -e "[${RED}-${C_DEFAULT}] Ending System."
			leaveSystem
		elif [[ $endcode -ne 0 ]]; then
			"$CORE/error" "${RED}Core.osstart terminated with unexpected return code: ${endcode}${C_DEFAULT}"
			exit 0
		fi
	else
		"$CORE/error" "${RED}Unable to load core. Aborting boot procedure.${C_DEFAULT}"
		exit 0
	fi
	"$CORE/uistart"
	if [[ "$?" == 0 ]]; then
		break
	fi
done
leaveSystem