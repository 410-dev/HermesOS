#!/bin/bash
if [[ -z "$lastExecutedCommand" ]]; then
	echo "There is no recent command."
	exit 0
else
	args=($lastExecutedCommand)
	if [[ -f "$SYSTEM/bin/${args[0]}" ]]; then
		"$SYSTEM/bin/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}" | tee -a "$LIBRARY/Logs/INTERFACE_$logSuffix.tlog"
		echo "$lastExecutedCommand" >> "$LIBRARY/Logs/history"
	elif [[ -z "$command" ]]; then
		echo -n ""
	else
		echo "Command not found: ${args[0]}"
		echo "$lastExecutedCommand" >> "$LIBRARY/Logs/history"
	fi
fi