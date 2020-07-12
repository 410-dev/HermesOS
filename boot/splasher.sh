#!/bin/bash
if [[ ! -z "$(echo $b_arg | grep "oldbootscreen")" ]]; then
	echo ""
	echo ""
	echo ""
	cat "$SYSTEM/boot/splasher.timg"
elif [[ ! -z "$(echo $b_arg | grep "enforce_cli")" ]]; then
	echo ""
	echo ""
	echo ""
	cat "$SYSTEM/boot/splasher.timg"
else
	export splashd="$(cat "$SYSTEM/boot/splasher2.timg")"
	$TDLIB/Services/GraphicSupport/GraphiteL/bin/TDGraphicalUIRenderer --infobox "$splashd" 11 84
fi