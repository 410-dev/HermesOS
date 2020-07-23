#!/bin/bash
export agentlist="$(<$SYSTEM/startupagents/agentlist)"
export exitStatus="0"
echo "$agentlist" | while read agentname
do
	if [[ ! -z "$agentname" ]]; then
		verbose "[*] Loading: $agentname"
		"$SYSTEM/lib/startupagents/$agentname" "$CACHE/definitions"
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