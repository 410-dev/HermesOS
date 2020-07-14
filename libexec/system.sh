#!/bin/bash

# --clean-restore : Reinstall system with update image. This is clean reinstallation, and requires an update image.
# --dirty-restore : Clear all user data. This does not reinstall system, but will restore to factory setting. This does not require an update image.
# --uirestart     : Restarts interface. Login will be required if password is setted.
# --update        : Run system update.
# --info          : Shows system information.
# --nvram-reset   : Clears all NVRAM data.
# --def-reload    : Reloads definitions.


if [[ "$1" == "--clean-restore" ]]; then
	if [[ -f "$NVRAM/upgrade.dmg" ]] || [[ -f "$NVRAM/rom.dmg" ]]; then
		touch "$NVRAM/clean-restore"
		echo "Shutting down..."
		"$SYSTEM/libexec/shutdown"
	else
		echo "Image not detected in NVCache space."
	fi
elif [[ "$1" == "--dirty-restore" ]]; then
	echo "File erase in progress..."
	rm -vrf "$DATA/"*
	echo "Shutting down..."
	"$SYSTEM/libexec/shutdown"
elif [[ "$1" == "--rollback" ]]; then
	if [[ -d "$DATA/preupgrade.system" ]]; then
		echo "Preparing for rollback..."
		hdiutil create -volname System -srcfolder "$DATA/preupgrade.system" -ov -format UDRW "$NVRAM/restore.dmg" >/dev/null
		touch "$NVRAM/do_rollback"
		echo "Shutting down..."
		"$SYSTEM/libexec/shutdown"
	else
		echo "Image not detected in NVCache space."
	fi
elif [[ "$1" == "--uirestart" ]]; then
	touch "$CACHE/SIG/shell_reload"
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
	profloc="$CACHE/init/TouchDown.System.SystemProfiler"
	echo "System Information"
	echo "OS Name: $(<$profloc/sys_name)"
	echo "Version: $(<$profloc/sys_version) (build $(<$profloc/sys_build))"
	echo "Compatibility: $(<$profloc/sys_compatibility)"
	echo "Manufacturer: $(<$profloc/sys_manufacture)"
	echo "Interface Version: $(<$profloc/interface_version)"
	profloc=""
elif [[ "$1" == "--nvram-reset" ]]; then
	echo "Reseting NVRAM..."
	rm -rf "$NVRAM"
	mkdir -p "$NVRAM"
	echo "Rewriting NVRAM..."
	cp -r "$TDLIB/defaults/nvram" "$DATA/"
	echo "Done."
elif [[ "$1" == "--def-reload" ]]; then
	touch "$CACHE/SIG/defreload"
elif [[ "$1" == "--logflush" ]]; then
	if [[ "$2" == "--nocopy" ]]; then
		echo "Logs will not be copied."
	else
		cp -r "$CACHE/logs" "$DATA"
	fi
	rm -rf "$CACHE/logs"
else
	echo "No such arguments."
fi