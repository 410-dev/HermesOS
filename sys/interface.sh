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
"$OSSERVICES/Library/Services/preload"
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

sysfunction execute


# Run files in $OSSERVICES/Library/Hooks/Login
sys_log "interface" "Running login hooks..."
PWDD="$(pwd)"
cd "$OSSERVICES/Library/Hooks/Login"
export SilenceAutoRun="$(regread USER/Shell/SilenceAutoRun)"
while read hook
do
	sys_log "interface" "Running login hook: $hook"
	if [[ "$SilenceAutoRun" == "1" ]]; then
		:
	else
		verbose "Running: ${RUNNING_LOGIN_HOOK}$hook"
	fi
	source "$OSSERVICES/Library/Hooks/Login/$hook"
	sys_log "interface" "Login hook complete: $hook"
done <<< "$(ls -p | grep -v / | grep ".hxe")"
sys_log "interface" "Login hooks complete."
cd "$PWDD"

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

	if [[ "$(regread USER/Shell/HaltAfterAutoRun)" == "1" ]]; then
		sys_log "interface" "HaltAfterAutoRun is enabled. Sending shutdown signal..."
		execCommand "shutdown"
	else
		read command
		execCommand "$command"
	fi
done