#!/bin/bash
clear
echo "HermesOS $OS_Version"
if [[ ! -f "$OSSERVICES/Utility/$(mplxr USER/INTERFACE/START_MODE)/runner" ]]; then
	echo "⛔️"
	verbose "Unable to load preload utility."
	while [[ true ]]; do
		sleep 1000
	done
else
	aopen "$OSSERVICES/Utility/$(mplxr USER/INTERFACE/START_MODE)"
fi