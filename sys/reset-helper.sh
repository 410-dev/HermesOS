#!/bin/bash
export ACTION="$1"
if [[ "$ACTION" == "update" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] Generating a rollback point..."
	mkdir -p "$LIBRARY/system-backup"
	cp -r "$SYSTEM/"* "$LIBRARY/system-backup"
	echo "[*] Making rollback image..."
	export pwdb="$PWD"
	cd "$LIBRARY/system-backup"
	tar -czpf "rbimage.tar.gz" --exclude=".*" --exclude="__MACOSX" .
	cd "$pwdb"
	mv "$LIBRARY/system-backup/rbimage.tar.gz" "$LIBRARY/rbimage.tar.gz"
	rm -rf "$LIBRARY/system-backup"
fi
verbose "[${GREEN}*${C_DEFAULT}] Cleaning system..."
rm -rf "$SYSTEM/"*
mkdir -p "$SYSTEM"
verbose "[${GREEN}*${C_DEFAULT}] Extracting system..."
if [[ -f "$LIBRARY/image.tar.gz" ]]; then
	tar -xf "$LIBRARY/image.tar.gz" -C "$ROOTFS"
elif [[ -f "$LIBRARY/image.zip" ]]; then
	unzip -q "$LIBRARY/image.zip" -d "$SYSTEM"
fi

if [[ -d "$SYSTEM/__MACOSX" ]]; then
	rm -rf "$SYSTEM/__MACOSX"
fi
if [[ -f "$OSSERVICES/Utility/convert" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] Running convert command..."
	"$OSSERVICES/Utility/convert" "$OS_Version_Major" "$OS_Version_Minor" 2>/dev/null
fi
if [[ "$ACTION" == "restore" ]]; then
	verbose "[${GREEN}*${C_DEFAULT}] Removing user data..."
	rm -rf "$LIBRARY"/* "$DATA"/*
	mkdir -p "$LIBRARY" "$DATA"
fi
if [[ -f "$SYSTEM/Boot/x64" ]]; then
	echo -e "[${GREEN}*${C_DEFAULT}] Adopting bootloader..."
	mkdir -p "$SYSTEM/boot"
	cp "$SYSTEM/Boot/x64" "$SYSTEM/boot/init" 2>/dev/null
	cp "$SYSTEM/Boot/Partitions" "$SYSTEM/boot/Partitions" 2>/dev/null
fi


echo "[*] Done."
mkdir -p "$CACHE"
touch "$CACHE/updated"
rm -rf "$NVRAM/bootaction"
exit 1