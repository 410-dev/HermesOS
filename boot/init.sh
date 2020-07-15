#!/bin/bash

function beginningOfSystem() {
	source "$(dirname "$0")/PLT"
	if [[ ! -z "$(echo $b_arg | grep "reset_nvram")" ]]; then
		rm -rf "$NVRAM"
		cp -r "$TDLIB/defaults/nvram" "$LIB"
	elif [[ ! -d "$NVRAM" ]]; then
		cp -r "$TDLIB/defaults/nvram" "$LIB"
	fi
	b_arg="$(<$NVRAM/boot_argument) $b_arg"
	if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
		"$SYSTEM/boot/osstart"
	else
		clear
		"$SYSTEM/boot/splasher"
		"$SYSTEM/boot/osstart" >/dev/null
	fi
	if [[ -f "$CACHE/upgraded" ]]; then
		rm -rf "$CACHE/"*
		if [[ ! -z "$(echo $b_arg | grep "bootergen2")" ]]; then
			echo "[*] Leaving..."
		else
			hdiutil detach "$CACHE" -force >/dev/null
			hdiutil detach "$DATA" -force >/dev/null
			hdiutil detach "$SYSTEM" -force >/dev/null; exit 0
		fi
	elif [[ -f "$CACHE/init-load-failed" ]] || [[ -f "$CACHE/framework-load-failed" ]]; then
		if [[ -f "$ROOTFS/Recovery/boot/init" ]]; then
			"$ROOTFS/Recovery/boot/init" "$ROOTFS"
		elif [[ -f "$SYSTEM/TouchDown/Library/Recovery/recovery.dmg" ]]; then
			mkdir -p "$ROOTFS/Recovery"
			hdiutil attach "$SYSTEM/TouchDown/Library/Recovery/recovery.dmg" -mountpoint "$ROOTFS/Recovery" >/dev/null
			"$ROOTFS/Recovery/boot/init" "$ROOTFS"
		elif [[ -f "$SYSTEM/TouchDown/Library/Recovery/lightrecovery.dmg" ]]; then
			mkdir -p "$ROOTFS/Recovery"
			hdiutil attach "$SYSTEM/TouchDown/Library/Recovery/lightrecovery.dmg" -mountpoint "$ROOTFS/Recovery" >/dev/null
			"$ROOTFS/Recovery/boot/init" "$ROOTFS"
		fi
		echo "[*] Stopping boot process..."
		rm -rf "$CACHE/"*
		if [[ ! -z "$(echo $b_arg | grep "bootergen2")" ]]; then
			echo "[*] Leaving..."
		else
			hdiutil detach "$CACHE" -force >/dev/null
			hdiutil detach "$DATA" -force >/dev/null
			hdiutil detach "$SYSTEM" -force >/dev/null; exit 0
		fi
	fi
	cd "$CACHE/def"
	for file in *.def
	do
		source "$file"
	done
}

function pseudoEndOfSystem(){
	if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
		echo "[*] Cleaning up frameworks cache..."
		rm -rf "$CACHE/Frameworks"
		echo "[*] Cleaning up signal cache..."
		rm -rf "$CACHE/SIG"
		echo "[*] Full-flushing cache..."
		rm -rf "$CACHE/" 2>/dev/null
		echo "[*] Closing..."
	else
		rm -rf "$CACHE/Frameworks"
		rm -rf "$CACHE/SIG"
		rm -rf "$CACHE/" 2>/dev/null
	fi
}

function realEndOfSystem(){
	if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
		echo "[*] Cleaning up frameworks cache..."
		rm -rf "$CACHE/Frameworks"
		echo "[*] Cleaning up signal cache..."
		rm -rf "$CACHE/SIG"
		echo "[*] Full-flushing cache..."
		rm -rf "$CACHE/" 2>/dev/null
		echo "[*] Closing..."
		if [[ ! -z "$(echo $b_arg | grep "bootergen2")" ]]; then
			echo "[*] Leaving..."
		else
			hdiutil detach "$CACHE" -force >/dev/null
			hdiutil detach "$SYSTEM" -force >/dev/null; exit 0
		fi
	else
		rm -rf "$CACHE/Frameworks"
		rm -rf "$CACHE/SIG"
		rm -rf "$CACHE/" 2>/dev/null
		if [[ ! -z "$(echo $b_arg | grep "bootergen2")" ]]; then
			echo "[*] Leaving..."
		else
			hdiutil detach "$CACHE" -force >/dev/null
			hdiutil detach "$SYSTEM" -force >/dev/null; exit 0
		fi
	fi
}

export b_arg="$1 $2 $3 $4 $5 $6 $7 $8 $9"

while [[ true ]]; do
	beginningOfSystem
	cd "$ROOTFS"
	"$SYSTEM/sbin/interface"
	if [[ -f "$CACHE/SIG/kernel_close" ]]; then
		echo "[*] Kernel close signal detected."
		realEndOfSystem
		break
	else
		pseudoEndOfSystem
		clear
		sleep 3
	fi
done
