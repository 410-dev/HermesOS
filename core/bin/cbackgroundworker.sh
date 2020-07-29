#!/bin/bash
export workerList="
"
export exitStatus="0"
echo "$workerList" | while read workerName
do
	if [[ ! -z "$workerName" ]]; then
		verbose "[*] Starting: $workerName"
		"$CORE/bgworkers/$workerName" "$CACHE/definition" &
		verbose "[*] Started: $workerName."
	fi
done
export workerList=""
exit 0