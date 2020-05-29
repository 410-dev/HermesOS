#!/bin/bash
export b_arg="$1 $2 $3 $4 $5 $6"
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	"$PWD/System/boot/osstart"
else
	clear
	"$PWD/System/boot/splasher"
	echo ""
	echo ""
	echo ""
	"$PWD/System/boot/osstart" >/dev/null
fi
cd "$PWD/cache/def"
for file in *.def
do
	source "$file"
done
cd "$VFS"
while [[ true ]]; do
	"$PWD/System/sbin/interface"
	if [[ -f "$PWD/cache/SIG/kernel_close" ]]; then
		echo "[*] Kernel close signal detected."
		break
	fi
done
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	echo "[*] Cleaning up frameworks cache..."
	rm -rf "$PWD/cache/Frameworks"
	echo "[*] Cleaning up signal cache..."
	rm -rf "$PWD/cache/SIG"
	echo "[*] Full-flushing cache..."
	rm -rf "$PWD/cache/" 2>/dev/null
	echo "[*] Closing..."
	hdiutil detach "$PWD/cache" -force >/dev/null
	echo "[*] Goodbye from kernel!"
	hdiutil detach "$PWD/System" -force >/dev/null; exit 0
else
	rm -rf "$PWD/cache/Frameworks"
	rm -rf "$PWD/cache/SIG"
	rm -rf "$PWD/cache/" 2>/dev/null
	hdiutil detach "$PWD/cache" -force >/dev/null
	hdiutil detach "$PWD/System" -force >/dev/null; exit 0
fi