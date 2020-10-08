#!/bin/bash
export agentlist="
HMCorePartitionBuilder.hxe
ISAIntegrity.hxe
"
export exitStatus="0"
echo "$agentlist" | while read agentname
do
	if [[ ! -z "$agentname" ]]; then
		verbose "[*] Loading: $agentname"
		"$CORE/extensions/$agentname"
		export returned=$?
		if [[ "$returned" == 0 ]]; then
			verbose "[*] Load complete."
		elif [[ -f "$BOOTREFUSE" ]]; then
			echo "❌"
			verbose "Boot refused: $(cat "$BOOTREFUSE")"
			exit 2
		else
			verbose "[!] $agentname returned exit code $returned."
			exitStatus=$returned
			break
		fi
	fi
done
export agentlist=""

export workerList="
"
echo "$workerList" | while read workerName
do
	if [[ ! -z "$workerName" ]]; then
		verbose "[*] Starting: $workerName"
		"$CORE/bgworkers/$workerName" &
		verbose "[*] Started: $workerName."
	fi
done
export workerList=""
exit "$exitStatus"