#!/bin/bash
if [[ -f "$CACHE/alert" ]] ; then
	cat "$CACHE/alert"
	rm "$CACHE/alert"
fi
if [[ "$(mplxr USER/INTERFACE/ALERT_PRESENT)" == "1" ]] ; then
	mplxr "USER/INTERFACE/ALERT"
	mplxw "USER/INTERFACE/ALERT_PRESENT" "0"
	mplxw "USER/INTERFACE/ALERT" ""
fi
