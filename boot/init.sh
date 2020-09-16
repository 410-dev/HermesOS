#!/bin/bash
echo "[[=====================]]"
echo "[[  HERMES BOOTLOADER  ]]"
echo "[[=====================]]"
source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/instructions.hdp"
if [[ -f "$LIBRARY/Services/cmem" ]]; then
	source "$LIBRARY/Services/cmem"
fi

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
		if [[ $? -ne 0 ]]; then
			echo "[-] CoreStart terminated with unexpected return code."
			exit 0
		fi
	else
		verbose "[!] ERROR: Unable to load core!"
		verbose "[-] Aborting boot procedure."
		exit 0
	fi
}

function loadDefinition(){
	if [[ -f "$CACHE/definitons" ]]; then
		source "$CACHE/definitons"
		rm -f "$CACHE/definitons"
	fi
	source "$CORE/resources/coreisa.hdp"
}

while [[ true ]]; do
	loadOS
	loadDefinition
	core.beginOSInterface
	if [[ "$exitcode" == 0 ]]; then
		break
	fi
done
leaveSystem