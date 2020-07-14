#!/bin/bash
source "$(dirname "$0")/PLT"
export b_arg="$1 $2 $3 $4 $5 $6 $7 $8 $9"
if [[ ! -z "$(echo $b_arg | grep "reset_nvram")" ]]; then
	rm -rf "$NVRAM"
	cp -r "$TDLIB/defaults/nvram" "$LIB"
elif [[ ! -d "$NVRAM" ]] ; then
	cp -r "$TDLIB/defaults/nvram" "$LIB"
fi
b_arg="$(<$NVRAM/boot_argument) $1 $2 $3 $4 $5 $6 $7 $8 $9"
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	"$SYSTEM/boot/osstart"
else
	clear
	"$SYSTEM/boot/splasher"
	"$SYSTEM/boot/osstart" >/dev/null
fi
if [[ -f "$CACHE/upgraded" ]]; then
	rm -rf "$CACHE/"*
	hdiutil detach "$CACHE" -force >/dev/null
	hdiutil detach "$DATA" -force >/dev/null
	hdiutil detach "$SYSTEM" -force >/dev/null; exit 0
fi
cd "$CACHE/def"
for file in *.def
do
	source "$file"
done
cd "$ROOTFS"
while [[ true ]]; do
	"$SYSTEM/sbin/interface"
	if [[ -f "$CACHE/SIG/kernel_close" ]]; then
		echo "[*] Kernel close signal detected."
		break
	fi
done
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	echo "[*] Cleaning up frameworks cache..."
	rm -rf "$CACHE/Frameworks"
	echo "[*] Cleaning up signal cache..."
	rm -rf "$CACHE/SIG"
	echo "[*] Full-flushing cache..."
	rm -rf "$CACHE/" 2>/dev/null
	echo "[*] Closing..."
	hdiutil detach "$CACHE" -force >/dev/null
	echo "[*] Goodbye from kernel!"
	hdiutil detach "$SYSTEM" -force >/dev/null; exit 0
else
	rm -rf "$CACHE/Frameworks"
	rm -rf "$CACHE/SIG"
	rm -rf "$CACHE/" 2>/dev/null
	hdiutil detach "$CACHE" -force >/dev/null
	hdiutil detach "$SYSTEM" -force >/dev/null; exit 0
fi