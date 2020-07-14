#!/bin/bash
@IMPORT Interface
if [[ ! -f "$NVRAM/clean-restore" ]]; then
	echo "[*] No request."
	exit 0
elif [[ "$(mplxr "SYSTEM/COMMON/CONFIGURE_DONE")" == "FALSE" ]]; then
	echo "[*] Detected first boot."
	exit 0
else
	echo "[*] Reset request detected."
	echo "[*] Checking system source..."
	if [[ ! -f "$NVRAM/upgrade.dmg" ]] && [[ ! -f "$NVRAM/rom.dmg" ]] ; then
		echo "[-] Unable to factory reset: Missing required file - $NVRAM/upgrade.dmg or rom.dmg"
		Interface.addAlert "System factory reset failed: Missing required files"
		exit 0
	fi
	echo "[*] Checking permission on system partition..."
	touch "$SYSTEM/onwrite" 2>/dev/null
	if [[ ! -f "$SYSTEM/onwrite" ]]; then
		echo "[*] Remount required."
		if [[ ! -d "$DISKSTORE_REALPATH" ]]; then
			echo "[-] System image realpath not detected. Unable to continue update process."
			Interface.addAlert "System update failed: System image realpath not detected."
			exit 0
		else
			echo "[*] Remounting /System..."
			hdiutil detach "$ROOTFS/System" -force >/dev/null
			hdiutil attach "$DISKSTORE_REALPATH/system.dmg" -mountpoint "$ROOTFS/System" >/dev/null
			export attachExitCode=$?
			touch "$SYSTEM/onwrite" 2>/dev/null
			if [[ "$attachExitCode" -ne "0" ]] || [[ ! -f "$SYSTEM/onwrite" ]]; then
				echo "[-] System remount failed."
				Interface.addAlert "System update failed: System remount as read and write failed."
				export attachExitCode=""
				exit 0
			fi
			export attachExitCode=""
		fi
	fi
	rm -f "$SYSTEM/onwrite"
	echo "[*] Mounting system partition..."
	mkdir -p "$DATA/mount/sysimg"
	if [[ -f "$NVRAM/upgrade.dmg" ]]; then
		mv "$NVRAM/upgrade.dmg" "$NVRAM/rom.dmg"
	fi
	hdiutil attach "$NVRAM/rom.dmg" -mountpoint "$DATA/mount/sysimg" -readonly >/dev/null
	echo "[*] Uploading helper tool to cache drive..."
	cp "$SYSTEM/sbin/reset-helper" "$CACHE/reset-helper"
	echo "[*] Starting helper."
	ALIVE=$(ps -ax | grep "$SYSTEM/frameworks[/]")
	echo "$ALIVE" | while read proc
	do
		frpid=($proc)
		kill -9 ${frpid[0]} 2>/dev/null
	done
	"$CACHE/reset-helper" --clean
	exit 0
fi