#!/bin/bash
@IMPORT Interface
if [[ ! -f "$NVRAM/update-install" ]]; then
	echo "[*] No request."
	exit 0
else
	rm "$NVRAM/update-install"
	echo "[*] Update detected."
	echo "[*] Updating system image..."
	echo "[*] Checking upgrade source..."
	if [[ ! -f "$NVRAM/upgrade.dmg" ]]; then
		echo "[-] Unable to update: Missing required file - $NVRAM/upgrade.dmg"
		Interface.addAlert "System update failed: Missing required files"
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
	mkdir -p "$DATA/mount/upgrade"
	hdiutil attach "$NVRAM/upgrade.dmg" -mountpoint "$DATA/mount/upgrade" -readonly >/dev/null
	echo "[*] Making a backup point."
	mkdir -p "$DATA/preupgrade.system"
	cp -r "$SYSTEM/" "$DATA/preupgrade.system/"
	echo "[*] Finished backup point generate."
	echo "[*] Upgrading system with simple copy..."
	cp -rv "$DATA/mount/upgrade/"* "$SYSTEM/"
	echo "[*] Upgrade complete."
	touch "$CACHE/upgraded"
	Interface.addAlert "Your system is now upgraded."
	ALIVE=$(ps -ax | grep "$SYSTEM/frameworks[/]")
	echo "$ALIVE" | while read proc
	do
		frpid=($proc)
		kill -9 ${frpid[0]} 2>/dev/null
	done
	exit 0
fi