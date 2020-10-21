#!/bin/bash
export ACTION="$1"
if [[ "$ACTION" == "update" ]]; then
	verbose "[*] Generating a rollback point..."
	mkdir -p "$LIBRARY/system-backup"
	cp -r "$SYSTEM/"* "$LIBRARY/system-backup"
	echo "[*] Making rollback image..."
	export pwdb="$PWD"
	cd "$LIBRARY/system-backup"
	zip -rq "rbimage.zip" . -x ".*" -x "__MACOSX"
	cd "$pwdb"
	mv "$LIBRARY/system-backup/rbimage.zip" "$LIBRARY/rbimage.zip"
	rm -rf "$LIBRARY/system-backup"
fi
verbose "[*] Cleaning system..."
rm -rf "$SYSTEM/"*
mkdir -p "$SYSTEM"
verbose "[*] Extracting system..."
unzip -q "$LIBRARY/image.zip" -d "$SYSTEM"
if [[ -d "$SYSTEM/__MACOSX" ]]; then
	rm -rf "$SYSTEM/__MACOSX"
fi
if [[ -f "$SYSTEMSUPPORT/Utility/convert" ]]; then
	verbose "[*] Running convert command..."
	"$SYSTEMSUPPORT/Utility/convert" "$OS_Version_Major" "$OS_Version_Minor" "$OS_Version_Edit"
fi
if [[ "$ACTION" == "restore" ]]; then
	verbose "[*] Removing user data..."
	rm -rf "$LIBRARY"/* "$DATA"/*
	mkdir -p "$LIBRARY" "$DATA"
fi
echo "[*] Done."
mkdir -p "$CACHE"
touch "$CACHE/updated"
rm -rf "$NVRAM/bootaction"