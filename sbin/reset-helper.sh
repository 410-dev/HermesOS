#!/bin/bash
if [[ "$1" == "--clean" ]]; then
	echo "Reset process started."
	echo "[1/4] Erasing all contents of /System..."
	rm -vrf "$SYSTEM/"*
	echo "[2/4] Copying new system from /Data/mount/sysimg..."
	cp -vr "$DATA/mount/sysimg/"* "$SYSTEM/"
	echo "[3/4] Unmounting image from /Data/mount/sysimg..."
	if [[ ! -z "$(echo "$b_arg" | grep "bootergen2")" ]]; then
		echo -n ""
	else
		hdiutil detach "$DATA/mount/sysimg" -force >/dev/null
	fi
	echo "[4/4] Erasing /Data partition..."
	rm -vrf "$DATA/"*
	touch "$CACHE/upgraded"
elif [[ "$1" == "--dirty" ]]; then
	echo "System reset process started."
	echo "[1/4] Erasing all contents of /System..."
	rm -vrf "$SYSTEM/"*
	echo "[2/4] Copying new system from /Data/mount/sysimg..."
	cp -vr "$DATA/mount/sysimg/"* "$SYSTEM/"
	echo "[3/4] Unmounting image from /Data/mount/sysimg..."
	if [[ ! -z "$(echo "$b_arg" | grep "bootergen2")" ]]; then
		echo -n ""
	else
		hdiutil detach "$DATA/mount/sysimg" -force >/dev/null
	fi
	rm -f "$NVRAM/do_rollback"
	echo "[4/4] Initializing NVRAM..."
	rm -rf "$NVRAM"
	mkdir -p "$NVRAM"
	touch "$CACHE/upgraded"
fi