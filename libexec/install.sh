#!/bin/bash
echo "TouchDown Package Installer"
if [[ -z "$1" ]]; then
	echo "[-] Package not specified."
	exit 9
fi
if [[ ! -f "$USERDATA/$1" ]]; then
	echo "[-] "
