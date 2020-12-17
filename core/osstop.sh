#!/bin/bash
verbose "[${GREEN}*${C_DEFAULT}] Loading lists of backgroundworkers..."
ALIVE=$(ps -ax | grep "$CORE/extensions[/]")
verbose "[${GREEN}*${C_DEFAULT}] Killing syncronously..."
verbose "$ALIVE" | while read proc
do
	if [[ ! -z "$proc" ]]; then
		frpid=($proc)
		kill -9 ${frpid[0]}
		verbose "[${GREEN}*${C_DEFAULT}] Killed PID: ${frpid[0]}"
	fi
done
verbose "[${GREEN}*${C_DEFAULT}] Background workers are closed."