#!/bin/bash
source "$(dirname "$0")/PLT"
export b_arg="$1 $2 $3 $4 $5 $6"
if [[ ! -z "$(echo $b_arg | grep "reset_nvram")" ]]; then
	rm -rf "$DATA/nvram"
	cp -r "$SYSTEM/TouchDown/defaults/nvram" "$DATA/"
elif [[ ! -d "$DATA/nvram" ]] ; then
	cp -r "$SYSTEM/TouchDown/defaults/nvram" "$DATA/"
fi
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	"$SYSTEM/boot/osstart"
else
	clear
	"$SYSTEM/boot/splasher"
	echo ""
	echo ""
	echo ""
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