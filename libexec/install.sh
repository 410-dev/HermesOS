#!/bin/bash
echo "TouchDown Package Installer"
if [[ -z "$1" ]]; then
	echo "[-] Package not specified."
	exit 9
fi
if [[ ! -d "$USERDATA/$1" ]]; then
	echo "[-] Package does not exists."
	exit 9
fi
if [[ "$1" -ne *.tdi ]]; then
	echo "[-] Unknown extension!"
	exit 9
fi
if [[ ! -d "$USERDATA/$1/payload" ]]; then
	echo "[-] Unable to find payload."
	exit 9
fi
if [[ ! -f "$USERDATA/$1/meta/targetloc" ]]; then
	echo "[-] Target undefined."
	exit 9
fi

# Replace with system function to test target existence

if [[ ! -d "$VFS$(<$USERDATA/$1/meta/targetloc)" ]]; then
	echo "[-] Specified target: $VFS$(<$USERDATA/$1/meta/targetloc) is not found."
	exit 9
fi
cp -vr "$USERDATA/$1/payload/"* "$VFS$(<$USERDATA/$1/meta/targetloc)/"
echo "[*] Done."