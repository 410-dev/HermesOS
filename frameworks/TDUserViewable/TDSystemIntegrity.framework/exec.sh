#!/bin/bash
if [[ "$(mplxr "SYSTEM/POLICY/isUsingImg")" == "TRUE" ]]; then
	while [[ true ]]; do	
		sleep 10
		touch "$SYSTEM/integrity_test" 2>/dev/null
		if [[ -f "$SYSTEM/integrity_test" ]]; then
			@IMPORT Interface
			Interface.addAlert "WARNING: System is writable!"
		fi
	done
else
	exit 0
fi