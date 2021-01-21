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

function verbose() {
	if [[ $(bootArgumentHas "verbose") == 1 ]]; then
		echo -e "$1"
	fi
}

function leaveSystem() {
	if [[ $(bootArgumentHas "no-cache-reset") == 0 ]]; then
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

function Log() {
	echo "$(date '+%Y %m %d %H:%M:%S') [ $1 ] $2" >> "$LIBRARY/Logs/$LOGFILENAME"
}

export -f bootArgumentHas
export -f verbose
export -f leaveSystem
export -f fallToRecovery
export -f Log
export LOGFILENAME="$(date '+%Y%m%d%H%M%S')"

# END OF INSTRUCTIONS

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

if [[ $(bootArgumentHas "recovery") == 1 ]]; then
	fallToRecovery
	leaveSystem
	exit 0
fi

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