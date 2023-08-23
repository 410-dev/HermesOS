#!/bin/bash
clear
echo "HermesOS $OS_Version"
if [[ ! -f "$OSSERVICES/Library/Utility/$(regread USER/Shell/StartupMode)/runner" ]]; then
	echo "⛔️"
	verbose "Unable to load preload utility."
	sys_log "preload" "Preload specification not found!"
	while [[ true ]]; do
		sleep 1000
	done
else
	sys_log "preload" "Starting preload: $(regread USER/Shell/StartupMode)"
	aopen "$OSSERVICES/Library/Utility/$(regread USER/Shell/StartupMode)"
fi
