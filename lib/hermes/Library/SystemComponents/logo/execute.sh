#!/bin/bash
if [[ $(bootarg.contains "verbose") == 0 ]]; then
	export splashd="$(cat "$OSSERVICES/hermes/Library/SystemComponents/logo/logo.asimg")"
	"$OSSERVICES/hermes/Library/SystemComponents/logo/display" --infobox "$splashd" 9 43
	afplay "$SYSTEMSUPPORT/Library/SystemComponents/sys_onStart.mp3"
else
	afplay "$SYSTEMSUPPORT/Library/SystemComponents/sys_onStart.mp3" &
fi