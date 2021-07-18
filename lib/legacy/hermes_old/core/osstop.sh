#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Loading lists of backgroundworkers..."
sys_log "OSStop" "Listing backgroundworkers..."
ALIVE="$(ps -ax | grep "$CORE/extensions[/]")
$(ps -ax | grep "$SYSTEM/bin[/]")
$(ps -ax | grep "$SYSTEM/sys[/]")
"
sys_log "OSStop" "Background workers: $ALIVE"
verbose "[${GREEN}*${C_DEFAULT}] Killing syncronously..."
sys_log "OSStop" "Killing all threads syncronously..."
verbose "$ALIVE" | while read proc
do
	if [[ ! -z "$proc" ]]; then
		frpid=($proc)
		kill -9 ${frpid[0]}
		sys_log "OSStop" "Killed: ${frpid[0]}"
		verbose "[${GREEN}*${C_DEFAULT}] Killed PID: ${frpid[0]}"
	fi
done
sys_log "OSStop" "All workers closed."
verbose "[${GREEN}*${C_DEFAULT}] Background workers are closed."