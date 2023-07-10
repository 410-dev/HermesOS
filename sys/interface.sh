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
	done <<< "$(ls -p | grep -v / | grep ".hmref")"
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


function execCommand() {
	command="$1"
	sys_log "interface" "Received input: $command"
	export args=($command)
	echo "${args[0]}" > "$CACHE/process"
	if [[ "${args[0]}" == "../"* ]]; then
		echo -e "$ESCAPE_NOT_ALLOWED"
		sys_log "interface" "Escape detected."
	elif [[ "${args[0]}" == "cd" ]]; then
		if [[ -z "${args[1]}" ]]; then
			echo "${MISSING_PARAM}Directory to enter"
		else
			if [[ -d "./${args[1]}" ]]; then
				@IMPORT FileIO
				if [[ "$(dopen "./${args[1]}")" == "0" ]]; then
					export ppw="$PWD"
					cd "./${args[1]}"
					if [[ "$PWD" == "$ROOTFS" ]]; then
						echo "${ACCESS_DENIED}Unaccessible location."
						cd "$ppw"
					fi
				else
					echo "${ACCESS_DENIED}Unaccessible location."
				fi
			else
				echo "No such directory: ${args[1]}"
			fi
		fi
	elif [[ -f "$SYSTEM/bin/${args[0]}" ]]; then
		if [[ "${args[0]}" == "lec" ]]; then
			echo -n ""
		else
			export lastExecutedCommand="$command"
			if [[ "${args[0]}" == "sudo" ]]; then
				echo "${args[1]}" > "$CACHE/process"
			else
				echo "${args[0]}" > "$CACHE/process"
			fi
		fi
		"$SYSTEM/bin/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}"
	elif [[ "$command" == "diagnostics" ]]; then
		diagnostics
	elif [[ -z "$command" ]]; then
		echo -n ""
	elif [[ "$(regread USER/Shell/DeveloperOptions)" == "1" ]]; then
		export lastExecutedCommand="$command"
		echo "${args[0]}" > "$CACHE/process"
		if [[ -f "$OSSERVICES/Library/Developer/bin/${args[0]}" ]]; then
			"$OSSERVICES/Library/Developer/bin/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}"
		else
			echo "${COMMAND_NOT_FOUND}${args[0]}"
		fi
	else
		echo "${COMMAND_NOT_FOUND}${args[0]}"
	fi
	if [[ -f "$CACHE/stdown" ]]; then
		sys_log "interface" "Shutdown signal received."
		sys_log "interface" "Flushing cache data..."
		verbose "$FLUSHING_CACHE_DATA"
		rm -rf "$CACHE"
		exit 0
	elif [[ -f "$CACHE/rboot" ]]; then
		sys_log "interface" "Reboot signal received."
		sys_log "interface" "Flushing cache data..."
		verbose "$FLUSHING_CACHE_DATA"
		rm -rf "$CACHE"
		exit 100
	elif [[ -f "$CACHE/uirestart" ]]; then
		sys_log "interface" "Restarting interface!"
		rm -f "$CACHE/uirestart"
		exit 101
	elif [[ -f "$CACHE/defreload" ]]; then
		sys_log "interface" "Reloading memory links..."
		echo "$RELOAD_WARNING"
		loadDefinition
	fi
}

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
		export OUTPUT_STYLE="${GREEN}${USERN}${C_DEFAULT}@${BLUE}${MACHN}${C_DEFAULT} ~ # "
	fi
	if [[ "$OUTPUT_STYLE" == "default" ]]; then
		export OUTPUT_STYLE="${GREEN}${USERN}${C_DEFAULT}@${BLUE}${MACHN}${C_DEFAULT} ~ # "
		regwrite "USER/Shell/LineStyle" "$OUTPUT_STYLE"
	fi
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