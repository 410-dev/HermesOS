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
export USERN=$(mplxr "USER/user_name")
export MACHN=$(mplxr "SYSTEM/machine_name")
if [[ -z "$USERN" ]]; then
	export USERN="root"
fi
if [[ -z "$MACHN" ]]; then
	export MACHN="apple_terminal"
fi
cd "$ROOTFS"

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
	echo -en "${GREEN}${USERN}${C_DEFAULT}@${BLUE}${MACHN}${C_DEFAULT} ~ # "
	read command
	sys_log "interface" "Recieved input: $command"
	export args=($command)
	echo "${args[0]}" > "$CACHE/process"
	if [[ "${args[0]}" == "../"* ]]; then
		echo -e "$ESCAPE_NOT_ALLOWED"
		sys_log "interface" "Escape detected."
	elif [[ -f "$SYSTEM/bin/${args[0]}" ]]; then
		if [[ "${args[0]}" == "lec" ]]; then
			echo -n ""
		else
			export lastExecutedCommand="$command"
			if [[ "${args[0]}" == "super" ]]; then
				echo "${args[1]}" > "$CACHE/process"
			else
				echo "${args[0]}" > "$CACHE/process"
			fi
		fi
		"$SYSTEM/bin/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}"
	elif [[ -z "$command" ]]; then
		echo -n ""
	elif [[ "$(mplxr USER/INTERFACE/DEVELOPER_OPTION)" == "1" ]]; then
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
		sys_log "interface" "Shutdown signal recieved."
		sys_log "interface" "Flushing cache data..."
		verbose "$FLUSHING_CACHE_DATA"
		rm -rf "$CACHE"
		exit 0
	elif [[ -f "$CACHE/rboot" ]]; then
		sys_log "interface" "Reboot signal recieved."
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
done