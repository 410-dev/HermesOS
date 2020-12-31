#!/bin/bash

if [[ "$1" == "--clean-restore" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		echo "Permission denied: $HUID"
		exit 0
	fi
	if [[ -f "$LIBRARY/image.zip" ]]; then
		echo "Preparing to restore..."
		echo "restore" > "$NVRAM/bootaction"
		echo "Shutting down..."
		"$SYSTEM/bin/shutdown"
	else
		echo "Image not detected in Library."
	fi
elif [[ "$1" == "--dirty-restore" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		echo "Permission denied: $HUID"
		exit 0
	fi

	echo "File erase in progress..."
	rm -vrf "$DATA/"*
	rm -vrf "$LIBRARY/"*
	echo "Shutting down..."
	"$SYSTEM/bin/shutdown"
elif [[ "$1" == "--rollback" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		echo "Permission denied: $HUID"
		exit 0
	fi

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
	if [[ "$HUID" -ne 0 ]]; then
		echo "Permission denied: $HUID"
		exit 0
	fi

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
	echo "Lock State: $OS_UnlockedDistro"
	echo "Copyright Statement: $OS_CopyrightStatement"
	echo ""
	echo "Hardware Information"
	echo "HardLink Version: $HardLink_Version"
	echo "Processor: $CPU_MANU $CPU_NAME $CPU_CLOCK ${CPU_CORES}-Core with $CPU_CACHE Cache"
	echo "Video: $VID_MANU - $VID_NAME with $VID_MEM_SIZE$VID_MEM_UNIT $VID_MEM_TYPE"
	echo "Memory: $MEM_SIZE$MEM_UNIT $MEM_MANU $MEM_NAME $MEM_CLOCK"
	echo "Disk: $DISK_MANU $DISK_NAME $DISK_SIZE$DISK_UNIT $DISK_TYPE Drive"
elif [[ "$1" == "--nvram-reset" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		echo "Permission denied: $HUID"
		exit 0
	fi

	echo -e "${RED}Are you sure you want to reset NVRAM?"
	echo -e "${RED}This action will reset all the frestrictor trusted data.${C_DEFAULT}"
	echo "y/n"
	read yn
	if [[ "$yn" == "y" ]] || [[ "$yn" == "Y" ]]; then
		echo "Reseting NVRAM..."
		rm -rf "$NVRAM"
		mkdir -p "$NVRAM"
		echo "Done."
	else
		echo "Aborted."
	fi 
elif [[ "$1" == "--logflush" ]]; then
	rm -rf "$LIBRARY/Logs"
	mkdir -p "$LIBRARY/Logs"
elif [[ "$1" == "--ota-download" ]]; then
	"$OSSERVICES/Library/Services/Update/dlutil"
elif [[ "$1" == "--extensions" ]]; then
	ls -1 "$LIBRARY/HardwareExtensions"
else
	echo "No such arguments."
fi