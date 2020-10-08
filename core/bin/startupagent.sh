#!/bin/bash
export agentlist="$(<"$OSSERVICES/startupagents/agentlist")"
echo "$agentlist" | while read agentname
do
	if [[ ! -z "$agentname" ]]; then
		verbose "[*] Loading: $agentname"
		"$OSSERVICES/startupagents/$agentname"
		export returned=$?
		if [[ "$returned" == 0 ]]; then
			verbose "[*] Load complete."
		else
			verbose "[!] $agentname returned exit code $returned."
			exit "$returned"
		fi
	fi
done
export masterdefinition=""
export agentlist=""