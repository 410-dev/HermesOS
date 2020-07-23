#!/bin/bash
export agentlist="
HMCorePartitionBuilder.hxe
HMCoreProfiler.hxe
"
export exitStatus="0"
echo "$agentlist" | while read agentname
do
	if [[ ! -z "$agentname" ]]; then
		verbose "[*] Loading: $agentname"
		"$CORE/cstartupagents/$agentname" "$CACHE/definitions"
		export returned=$?
		if [[ "$returned" == 0 ]]; then
			verbose "[*] Load complete."
		else
			verbose "[!] $agentname returned exit code $returned."
			exitStatus=$returned
			break
		fi
	fi
done
export masterdefinition=""
export agentlist=""
exit "$exitStatus"