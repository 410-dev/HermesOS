#!/bin/bash
cat "$OSSERVICES/backgroundworkers/workerslist" | while read workerName
do
	if [[ ! -z "$workerName" ]]; then
		verbose "[*] Starting: $workerName"
		"$OSSERVICES/backgroundworkers/$workerName" "$CACHE/definition" & 2>/dev/null >/dev/null
		verbose "[*] Started: $workerName."
	fi
done
exit 0