#!/bin/bash

if [[ "$HUID" -ne 0 ]]; then
	echo "Permission denied: $HUID"
	exit 0
fi

if [[ "$1" == "--clean-restore" ]]; then
	if [[ -f "$LIBRARY/image.zip" ]]; then
		echo "Preparing to restore..."
		echo "restore" > "$NVRAM/bootaction"
		echo "Shutting down..."
		"$SYSTEM/bin/shutdown"
	else
		echo "Image not detected in Library."
	fi
elif [[ "$1" == "--dirty-restore" ]]; then
	echo "File erase in progress..."
	rm -vrf "$DATA/"*
	rm -vrf "$LIBRARY/"*
	echo "Shutting down..."
	"$SYSTEM/bin/shutdown"
elif [[ "$1" == "--rollback" ]]; then
	if [[ -f "$LIBRARY/rbimage.zip" ]]; then
		echo "Preparing for rollback..."
		mv "$LIBRARY/rbimage.zip" "$LIBRARY/image.zip"
		echo "rollback" > "$NVRAM/bootaction"
		echo "Shutting down..."
		"$SYSTEM/bin/shutdown"
	else
		echo "Rollback image not found."
	fi
elif [[ "$1" == "--uirestart" ]]; then
	touch "$CACHE/uirestart"
elif [[ "$1" == "--update" ]]; then
	if [[ -f "$LIBRARY/image.zip" ]] || [[ -f "$USERDATA/update.zip" ]]; then
		echo "Preparing for update..."
		if [[ -f "$USERDATA/update.zip" ]]; then
			mv "$USERDATA/update.zip" "$LIBRARY/image.zip"
		fi
		echo "update" > "$NVRAM/bootaction"
		echo "Shutting down..."
		"$SYSTEM/bin/shutdown"
	else
		echo "System update not detected."
	fi
elif [[ "$1" == "--info" ]]; then
	echo "System Information"
	echo "OS Name: $OS_Name $OS_Codename"
	echo "Version: $OS_Version (build $OS_Build)"
	echo "Kernel: $CoreName - $CoreVersion"
	echo "Manufacturer: $OS_Manufacture"
	echo "Interface Version: $OS_InterfaceVersion"
	echo "Copyright Statement: $OS_CopyrightStatement"
elif [[ "$1" == "--nvram-reset" ]]; then
	echo -e "${RED}Are you sure you want to reset NVRAM?"
	echo -e "${RED}This action will reset all the frestrictor trusted data.${DEFAULT}"
	echo "y/n"
	read yn
	if [[ "$yn" == "y" ]] || [[ "$yn" == "Y" ]]; then
		echo "Reseting NVRAM..."
		rm -rf "$NVRAM"
		mkdir -p "$NVRAM"
		echo "Rewriting NVRAM..."
		cp -r "$SYSTEMSUPPORT/defaults/nvram" "$LIB"
		echo "Done."
	else
		echo "Aborted."
	fi 
elif [[ "$1" == "--logflush" ]]; then
	rm -rf "$LIBRARY/Logs"
	mkdir -p "$LIBRARY/Logs"
elif [[ "$1" == "--ota-download" ]]; then
	"$OSSERVICES/Library/Services/Update/dlutil"
else
	echo "No such arguments."
fi