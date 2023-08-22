#!/bin/bash
clear_setuplang
sys_log "interface" "Cleared setup language set."
function loadDefinition() {
	cd "$CORE/extensions"
	while read defname
	do
		sys_log "interface" "Reloading memory link: $defname"
		verbose "${REFRESHING_MEMORYLINK}$defname"
		source "$CORE/extensions/$defname"
		sys_log "interface" "Memory link updated: $defname"
	done <<< "$(ls -p | grep -v / | grep ".hfunc")"
}

sys_log "interface" "Running preload..."
"$OSSERVICES/Utility/preload"
sys_log "interface" "Logged in."
sys_log "interface" "Getting registry data..."
export USERN=$(regread "USER/UserName")
export MACHN=$(regread "MACHINE/MachineName")
if [[ -z "$USERN" ]]; then
	export USERN="root"
fi
if [[ -z "$MACHN" ]]; then
	export MACHN="apple_terminal"
fi
cd "$USERDATA"

source "$OSSERVICES/Library/Services/Functions/ExecCommand.hfunc"

export AutoRunComplete=0

while [[ true ]]; do
	sys_log "interface" "Setting default permission value..."
	declare -i HUID
	if [[ "$OS_UnlockedDistro" == "Unlocked" ]]; then
		export HUID="0"
		sys_log "interface" "System is unlocked. Setting permission value to 0."
	else
		export HUID="1"
		sys_log "interface" "System is locked. Setting permission value to 1."
	fi

	if [[ -f "$CACHE/alert" ]] ; then
		sys_log "interface" "Alert present: $(cat "$CACHE/alert")"
		cat "$CACHE/alert"
		rm "$CACHE/alert"
	fi
	export OUTPUT_STYLE="$(regread USER/Shell/LineStyle)"
	if [[ "$OUTPUT_STYLE" == "null" ]]; then
		export OUTPUT_STYLE="${GREEN}%USERNAME%${C_DEFAULT}@${BLUE}%MACHINENAME%${C_DEFAULT} %PWD% # "
	fi
	if [[ "$OUTPUT_STYLE" == "default" ]]; then
		export OUTPUT_STYLE="${GREEN}%USERNAME%${C_DEFAULT}@${BLUE}%MACHINENAME%${C_DEFAULT} %PWD% # "
		regwrite "USER/Shell/LineStyle" "$OUTPUT_STYLE"
	fi
	export OUTPUT_STYLE="${OUTPUT_STYLE//%USERNAME%/$USERN}"
	export OUTPUT_STYLE="${OUTPUT_STYLE//%MACHINENAME%/$MACHN}"
	export OUTPUT_STYLE="${OUTPUT_STYLE//%PWD%/$PWD}"
	export OUTPUT_STYLE="${OUTPUT_STYLE//$USERDATA/~}"
	export OUTPUT_STYLE="${OUTPUT_STYLE//$ROOTFS/}"
	echo -en "$OUTPUT_STYLE"
	if [[ "$AutoRunComplete" == "0" ]]; then
		export AutoRunList="$(regread USER/Shell/AutoRun)"
		export AutoRunEnabled="$(regread USER/Shell/AutoRunEnabled)"

		if [[ "$AutoRunEnabled" == "1" ]]; then
			sys_log "interface" "AutoRun enabled. Running AutoRun list..."

			if [[ "$(regread USER/Shell/EnableAutoRunFromRegistries)" == "0" ]]; then
				sys_log "interface" "AutoRun from registries disabled by registry value. Skipping AutoRun list..."
			else
				sys_log "interface" "AutoRun list from registry: $AutoRunList"	
				IFS_ORIG=$IFS
				IFS=";"
				read -ra substrings <<< "$AutoRunList"
				IFS=$IFS_ORIG
				for substring in "${substrings[@]}"; do
					trimmed_substring=$(echo "$substring" | sed 's/^[[:space:]]*//')
					if [ -z "$trimmed_substring" ]; then
						continue
					fi
					sys_log "interface" "AutoRun command: $trimmed_substring"
					execCommand "$trimmed_substring"
				done
			fi

			if [[ "$(regread USER/Shell/EnableAutoRunFromFile)" -ne "0" ]]; then
				sys_log "interface" "AutoRun from filesystem disabled by registry value. Skipping AutoRun list..."
			else
				sys_log "interface" "AutoRun list from filesystem: $ROOTFS/AUTORUN"
				if [[ -f "$ROOTFS/AUTORUN" ]]; then
					sys_log "interface" "AutoRun list found. Running AutoRun list..."
					sys_log "interface" "AutoRun list: $(cat "$ROOTFS/AUTORUN")"
					while read command
					do
						execCommand "$command"
					done <<< "$(cat "$ROOTFS/AUTORUN")"
				else
					sys_log "interface" "AutoRun list not found."
				fi
			fi
		else
			sys_log "interface" "AutoRun disabled. Skipping AutoRun list..."
		fi
		export AutoRunComplete=1
	fi

	if [[ "$(regread USER/Shell/HaltAfterAutoRun)" == "1" ]]; then
		sys_log "interface" "HaltAfterAutoRun is enabled. Sending shutdown signal..."
		execCommand "shutdown"
	else
		read command
		execCommand "$command"
	fi
done