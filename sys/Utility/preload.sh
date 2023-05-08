#!/bin/bash
clear
echo "HermesOS $OS_Version"
if [[ ! -f "$OSSERVICES/Utility/$(mplxr USER/INTERFACE/START_MODE)/runner" ]]; then
	echo "⛔️"
	verbose "Unable to load preload utility."
	sys_log "preload" "Preload specification not found!"
	while [[ true ]]; do
		sleep 1000
	done
else
	sys_log "preload" "Starting preload: $(mplxr USER/INTERFACE/START_MODE)"
	aopen "$OSSERVICES/Utility/$(mplxr USER/INTERFACE/START_MODE)"
fi
