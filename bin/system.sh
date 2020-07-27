#!/bin/bash
if [[ "$1" == "--clean-restore" ]]; then
	if [[ -f "$NVRAM/upgrade.dmg" ]] || [[ -f "$NVRAM/rom.dmg" ]]; then
		touch "$NVRAM/clean-restore"
		echo "Shutting down..."
		"$SYSTEM/bin/shutdown"
	else
		echo "Image not detected in NVRAM space."
	fi
elif [[ "$1" == "--dirty-restore" ]]; then
	echo "File erase in progress..."
	rm -vrf "$DATA/"*
	rm -vrf "$LIBRARY/"*
	echo "Shutting down..."
	"$SYSTEM/bin/shutdown"
elif [[ "$1" == "--rollback" ]]; then
	if [[ -d "$LIBRARY/preupgrade.system" ]]; then
		echo "Preparing for rollback..."
		hdiutil create -volname System -srcfolder "$LIBRARY/preupgrade.system" -ov -format UDRW "$NVRAM/restore.dmg" >/dev/null
		touch "$NVRAM/do_rollback"
		echo "Do you want to erase old image after rollback?"
		read yn
		if [[ "$yn" == "Y" ]] || [[ "$yn" == "y" ]]; then
			rm -rf "$LIBRARY/preupgrade.system"
		fi
		echo "Shutting down..."
		"$SYSTEM/bin/shutdown"
	else
		echo "Image not detected in NVRAM space."
	fi
elif [[ "$1" == "--uirestart" ]]; then
	touch "$CACHE/uirestart"
elif [[ "$1" == "--update" ]]; then
	if [[ -f "$NVRAM/upgrade.dmg" ]]; then
		touch "$NVRAM/update-install"
		echo "Update will be installed on next boot."
	elif [[ -f "$DATA/User/update.tdupdate" ]];then
		echo "Found update file."
		mv "$DATA/User/update.tdupdate" "$NVRAM/upgrade.dmg"
		touch "$NVRAM/update-install"
		echo "Update will be installed on next boot."
	else
		echo "System update not detected."
	fi
elif [[ "$1" == "--info" ]]; then
	echo "System Information"
	echo "OS Name: $OS_Name"
	echo "Version: $OS_Version (build $OS_Build)"
	echo "Manufacturer: $OS_Manufacture"
	echo "Interface Version: $OS_InterfaceVersion"
	echo "Copyright Statement: $OS_CopyrightStatement"
elif [[ "$1" == "--nvram-reset" ]]; then
	echo "Reseting NVRAM..."
	rm -rf "$NVRAM"
	mkdir -p "$NVRAM"
	echo "Rewriting NVRAM..."
	cp -r "$TDLIB/defaults/nvram" "$LIB"
	echo "Done."
elif [[ "$1" == "--logflush" ]]; then
	rm -rf "$LIBRARY/Logs"
	mkdir -p "$LIBRARY/Logs"
else
	echo "No such arguments."
fi