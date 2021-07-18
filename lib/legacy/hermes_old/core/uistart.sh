#!/bin/bash
if [[ -f "$OSSERVICES/interface" ]]; then
	sys_log "UIStart" "OS Interface found."
	export exitcode=1
	while [[ $exitcode -ne 0 ]] && [[ $exitcode -ne 100 ]]; do
		sys_log "UIStart" "Instruction: $exitcode"
		sys_log "UIStart" "Launching interface!"
		"$OSSERVICES/interface"
		exitcode="$?"
	done
	sys_log "UIStart" "Instruction: $exitcode"
	sys_log "UIStart" "Stopping OS..."
	"$CORE/osstop"
	exit "$exitcode"
else
	sys_log "UIStart" "OS Interface not found."
	sys_log "UIStart" "Stopping core."
	echo -e "[${RED}-${C_DEFAULT}] OS Interface not found."
	echo -e "[${RED}-${C_DEFAULT}] Stopping core."
	"$CORE/osstop"
	exit 0
fi