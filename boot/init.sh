#!/bin/bash
source "$(dirname "$0")/partitions.hdp"

# INSTRUCTIONS
function bootArgumentHas() {
	if [[ ! -z "$(echo "$BOOTARGS" | grep "$1")" ]]; then
		echo 1
	else
		echo 0
	fi
}

function bootarg.contains() { # This is legacy instruction. Delete on Hermes13.
	bootArgumentHas
}

function verbose() {
	if [[ $(bootarg.contains "verbose") == 1 ]]; then
		echo -e "$1"
	fi
}

function leaveSystem() {
	if [[ $(bootarg.contains "no-cache-reset") == 0 ]]; then
		rm -rf "$CACHE" 2>/dev/null
		exit 0
	fi
	
}

function fallToRecovery() {
	mkdir -p "$RECOVERY"
	echo "Entering recovery..."
	cp -r "$OSSERVICES/Library/RecoveryOS/"* "$RECOVERY"
	"$RECOVERY/BOOT"
}

export -f bootarg.contains
export -f bootArgumentHas
export -f verbose
export -f leaveSystem
export -f fallToRecovery

# END OF INSTRUCTIONS

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

if [[ $(bootarg.contains "recovery") == 1 ]]; then
	fallToRecovery
	leaveSystem
	exit 0
fi

while [[ $(bootarg.contains "recovery") == 0 ]]; do
	verbose "[${GREEN}*${C_DEFAULT}] Starting Hermes..."
	if [[ -f "$CORE/core" ]]; then
		"$CORE/core" "osstart"
		export endcode=$?
		if [[ -f "$BOOTREFUSE" ]]; then
			echo -e "[${RED}-${C_DEFAULT}] Ending System."
			leaveSystem
		elif [[ $endcode -ne 0 ]]; then
			"$CORE/core" "error" "${RED}Core.osstart terminated with unexpected return code: ${endcode}${C_DEFAULT}"
			exit 0
		fi
	else
		"$CORE/core" "error" "${RED}Unable to load core. Aborting boot procedure.${C_DEFAULT}"
		exit 0
	fi
	"$CORE/rmleak"
	"$CORE/core" "uistart"
	if [[ "$?" == 0 ]]; then
		break
	fi
done
leaveSystem