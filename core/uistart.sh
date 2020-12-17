#!/bin/bash
if [[ -f "$OSSERVICES/interface" ]]; then
	export exitcode=1
	while [[ $exitcode -ne 0 ]] && [[ $exitcode -ne 100 ]]; do
		"$OSSERVICES/interface"
		exitcode="$?"
	done
	"$CORE/osstop"
	exit "$exitcode"
else
	echo -e "[${RED}-${C_DEFAULT}] OS Interface not found."
	echo -e "[${RED}-${C_DEFAULT}] Stopping core."
	"$CORE/osstop"
	exit 0
fi