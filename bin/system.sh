#!/bin/bash

if [[ "$1" == "--clean-restore" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		echo "${PERMISSION_DENIED}$HUID"
		exit 0
	fi
	if [[ -f "$LIBRARY/image.tar.gz" ]]; then
		echo "Preparing to restore..."
		echo "restore" > "$NVRAM/bootaction"
		echo "Shutting down..."
		"$SYSTEM/bin/shutdown"
	else
		echo "Image not detected in Library."
	fi
elif [[ "$1" == "--dirty-restore" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		echo "${PERMISSION_DENIED}$HUID"
		exit 0
	fi

	echo "File erase in progress..."
	rm -vrf "$DATA/"*
	rm -vrf "$LIBRARY/"*
	echo "Shutting down..."
	"$SYSTEM/bin/shutdown"
elif [[ "$1" == "--rollback" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		echo "${PERMISSION_DENIED}$HUID"
		exit 0
	fi

	if [[ -f "$LIBRARY/rbimage.tar.gz" ]]; then
		echo "Preparing for rollback..."
		mv "$LIBRARY/rbimage.tar.gz" "$LIBRARY/image.tar.gz"
		echo "rollback" > "$NVRAM/bootaction"
		echo "Shutting down..."
		"$SYSTEM/bin/shutdown"
	else
		echo "Rollback image not found."
	fi
elif [[ "$1" == "--uirestart" ]]; then
	touch "$CACHE/uirestart"
elif [[ "$1" == "--update-legacy" ]]; then
	if [[ "$(regread "USER/System/Legacy/EnableLegacyUpdate")" -ne "1" ]]; then
		echo "Legacy update is unsupported."
		exit 0
	fi

	if [[ "$HUID" -ne 0 ]]; then
		echo "${PERMISSION_DENIED}$HUID"
		exit 0
	fi

	if [[ -f "$LIBRARY/image.zip" ]]; then

		if [[ "$(FIRMWARE_INFO virtualization)" == "1" ]]; then
			echo "Your system supports virtualization."
			echo "It is highly recommended that you use the virtualization."
			echo "Do you want to continue with the legacy update? (y/n)"
			read -r -n 1 -s
			if [[ "$REPLY" != "y" ]] && [[ "$REPLY" != "Y" ]]; then
				echo "Aborted."
				exit 0
			fi
		fi

		echo -e "${RED}WARNING: Legacy update is not recommended.${C_DEFAULT}"
		echo -e "${YELLOW}This may damage your system and cause data loss.${C_DEFAULT}"
		echo -e "${YELLOW}Please backup your data before continuing.${C_DEFAULT}"
		echo -e "${YELLOW}Do you want to continue? (y/n)${C_DEFAULT}"
		read -r -n 1 -s
		if [[ "$REPLY" != "y" ]] && [[ "$REPLY" != "Y" ]]; then
			echo "Aborted."
			exit 0
		fi

		echo "Preparing for update..."
		echo "Setting LiteOS to update mode..."
		cp "$OSSERVICES/Library/Legacy/Compatibility/LegacyOSInstall.litescript" "$ROOTFS/TERMINATE.litescript"
		echo "Shutting down and entering LiteOS interpreter mode..."
		"$SYSTEM/bin/shutdown"
	else
		echo "System update not detected."
	fi
elif [[ "$1" == "--update" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		echo "${PERMISSION_DENIED}$HUID"
		exit 0
	fi

	if [[ -f "$LIBRARY/image.tar.gz" ]] || [[ -f "$USERDATA/update.tar.gz" ]]; then
		echo "Preparing for update..."
		if [[ -f "$USERDATA/update.tar.gz" ]]; then
			mv "$USERDATA/update.tar.gz" "$LIBRARY/image.tar.gz"
		fi
		echo "update" > "$NVRAM/bootaction"
		echo "Shutting down..."
		"$SYSTEM/bin/shutdown"
	else
		echo "System update not detected."
	fi
elif [[ "$1" == "--info" ]]; then
	echo "System Information"
	echo "OS Name: $OS_Name"
	echo "Version: $OS_Version (build $OS_Build)"
	echo "Kernel: $CoreName - $CoreVersion"
	echo "Vendor: $OS_Vendor"
	echo "Interface Version: $OS_InterfaceVersion"
	echo "Lock State: $OS_UnlockedDistro"
	echo "System Mode: $OS_ProSystemStatus"
	echo "Language: $LANG_ID"
	echo "Copyright Statement: $OS_CopyrightStatement"
	if [[ "$2" == "--detail" ]]; then
		echo ""
		echo "Hardware Information"
		echo "HardLink Version: $HardLink_Version"
		echo "Processor: $CPU_MANU $CPU_NAME $CPU_CLOCK ${CPU_CORES}-Core with $CPU_CACHE Cache"
		echo "Video: $VID_MANU - $VID_NAME with $VID_MEM_SIZE$VID_MEM_UNIT $VID_MEM_TYPE"
		echo "Memory: $MEM_SIZE$MEM_UNIT $MEM_MANU $MEM_NAME $MEM_CLOCK"
		echo "Disk: $DISK_MANU $DISK_NAME $DISK_SIZE$DISK_UNIT $DISK_TYPE Drive"
		echo ""
		echo "Detailed Information"
		echo "Boot arguments: ${BOOTARGS}"
		if [[ $(bootArgumentHas "safe") == "1" ]]; then
			echo "Safe Mode: Enabled"
		else
			echo "Safe Mode: Disabled"
		fi
		if [[ $(bootArgumentHas "no-firm-support") == "1" ]]; then
			echo "Firmware Support: Disabled (Unsafe)"
		else
			echo "Firmware Support: Enabled"
		fi
		echo "Firmware Version: $(FIRMWARE_INFO version)"
		echo "Firmware Vendor: $(FIRMWARE_INFO vendor)"
		echo "Virtualization: $(FIRMWARE_INFO virtualization)"
		echo "Encryption: $(FIRMWARE_INFO encryption)"
		echo "Isolation: $(FIRMWARE_INFO isolation)"
		if [[ ! -z "$(LITE_HELP)" ]]; then
			echo "LiteOS Support: Enabled"
		else
			echo "LiteOS Support: Disabled"
		fi
	fi
elif [[ "$1" == "--logflush" ]]; then
	rm -rf "$LIBRARY/Logs"
	mkdir -p "$LIBRARY/Logs"
elif [[ "$1" == "--ota-download" ]]; then
	if [[ "$2" == "--legacy" ]] && [[ "$(regread "USER/System/Legacy/EnableLegacyUpdate")" == *"1"* ]]; then
		"$OSSERVICES/Library/Legacy/Services/Update/dlutil"
	else
		"$OSSERVICES/Library/Services/Update/dlutil"
	fi
elif [[ "$1" == "--extensions" ]]; then
	if [[ -d "$LIBRARY/HardwareExtensions" ]]; then
		ls -1 "$LIBRARY/HardwareExtensions"
	fi
else
	echo "No such arguments."
fi