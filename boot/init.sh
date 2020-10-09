#!/bin/bash
source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/instructions.hdp"

# Added for HermesOS
if [[ -f "$NVRAM/boot_argument" ]]; then
	export BOOTARGS="$BOOTARGS $(<"$NVRAM/boot_argument")"
fi
if [[ -f "$NVRAM/boot_reference" ]]; then
	cp "$NVRAM/boot_reference" "$CACHE/bootconf"
	chmod +x "$CACHE/bootconf"
	source "$CACHE/bootconf"
	rm -f "$CACHE/bootconf"
fi

export BOOTARGS="$BOOTARGS $1 $2 $3 $4 $5 $6 $7 $8 $9"

function loadOS() {
	if [[ -f "$SYSTEM/boot/bootscreen.hxe" ]] && [[ $(bootarg.contains "verbose") == 0 ]]; then
		"$SYSTEM/boot/bootscreen.hxe"
	fi
	verbose "[*] Starting Hermes..."
	if [[ -f "$CORE/bin/corestart" ]]; then
		"$CORE/bin/corestart"
		export endcode=$?
		if [[ -f "$BOOTREFUSE" ]]; then
			echo "Ending System."
			leaveSystem
		elif [[ $endcode -ne 0 ]]; then
			"$CORE/bin/error" "CoreStart terminated with unexpected return code: $endcode"
			exit 0
		fi
	else
		"$CORE/bin/error" "Unable to load core. Aborting boot procedure."
		exit 0
	fi
}

function loadDefinition(){
	source "$CORE/coreisa"
}

while [[ true ]]; do
	loadDefinition
	loadOS
	core.beginOSInterface
	if [[ "$exitcode" == 0 ]]; then
		break
	fi
done
leaveSystem