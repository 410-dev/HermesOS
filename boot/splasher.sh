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
	if [[ -f "$NVRAM/update-install" ]]; then
		export splashd="$(cat "$SYSTEM/boot/splasher-update.timg")"
	elif [[ -f "$NVRAM/do_rollback" ]]; then
		export splashd="$(cat "$SYSTEM/boot/splasher-rollback.timg")"
	elif [[ -f "$NVRAM/clean-restore" ]]; then
		export splashd="$(cat "$SYSTEM/boot/splasher-restore.timg")"
	else
		export splashd="$(cat "$SYSTEM/boot/splasher-boot.timg")"
	fi
	$TDLIB/Services/GraphicSupport/GraphiteL/bin/TDGraphicalUIRenderer --infobox "$splashd" 11 84
fi