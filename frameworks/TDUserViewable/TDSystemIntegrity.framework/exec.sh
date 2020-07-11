#!/bin/bash
if [[ "$(mplxr "SYSTEM/POLICY/isUsingImg")" == "TRUE" ]]; then
	while [[ true ]]; do	
		sleep 5
		touch "$SYSTEM/integrity_test" 2>/dev/null
		if [[ -f "$SYSTEM/integrity_test" ]]; then
			echo "SYSTEM WARNING: System partition is writable!"
		fi
	done
else
	exit 0
fi