#!/bin/bash
if [[ $(bootArgumentHas "verbose") == 0 ]]; then
	export splashd="$(cat "$OSSERVICES/Library/Services/Startup/logo/logo.asimg")"
	"$OSSERVICES/Library/display" --infobox "$splashd" 9 43
	if [[ -f "$OSSERVICES/Library/Services/Startup/sys_onStart.mp3" ]]; then
		afplay "$OSSERVICES/Library/Services/Startup/sys_onStart.mp3" &
	fi
	sleep 1
else
	cat "$OSSERVICES/Library/Services/Startup/logo/logo_vbm.asimg"
	if [[ -f "$OSSERVICES/Library/Services/Startup/sys_onStart.mp3" ]]; then
		afplay "$OSSERVICES/Library/Services/Startup/sys_onStart.mp3" &
	fi
fi