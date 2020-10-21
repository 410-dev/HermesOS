#!/bin/bash
if [[ $(bootarg.contains "verbose") == 0 ]]; then
	export splashd="$(cat "$OSSERVICES/Library/SystemComponents/logo/logo.asimg")"
	"$OSSERVICES/Library/display" --infobox "$splashd" 9 43
	afplay "$OSSERVICES/Library/SystemComponents/sys_onStart.mp3" &
	sleep 2
else
	afplay "$OSSERVICES/Library/SystemComponents/sys_onStart.mp3" &
fi