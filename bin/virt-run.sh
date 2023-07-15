#!/bin/bash

# Check if virtualizable
if [[ "$(bootArgumentHas "vm.nested=1")" == 1 ]]; then
    echo "Nested virtualization is unavailable."
    exit 90
fi
if [[ "$(FIRMWARE_INFO "virtualization")" -ne "1" ]]; then
    echo "Virtualization is unavailable."
    exit 90
fi

# Get first parameter (container name)
if [[ -z "$1" ]]; then
    echo "Missing container name."
    exit 90
fi
if [[ "$1" == "."* ]]; then
    echo "Invalid container name."
    exit 90
fi  

if [[ ! -d "$USERDATA/VirtualMachines/containers/$1" ]]; then
    echo "Container does not exist."
    exit 90
fi

if [[ ! -f "$USERDATA/VirtualMachines/containers/$1/disk/System/boot/firm" ]] && [[ ! -f "$USERDATA/VirtualMachines/containers/$1/disk/System/boot/init" ]]; then
    echo "Container does not have valid bootloader."
    echo "Virtual machine must contain either 'System/boot/firm' or 'System/boot/init' file."
    exit 90
fi

currentWorkingDirectory="$(pwd)"
ContainerName="$1"
Firmware="$2"
if [[ "$Firmware" == "--firm" ]]; then
    shift
    shift
else
    shift
fi
Parameters="$@"

if [[ "$(regread SYSTEM/Virtualization/AllowNestedVM)" -ne "1" ]]; then
    Parameters="$Parameters vm.nested=1"
fi

# Check legacy and patch boot files according to it.
echo "Patching partition map..."

if [[ -f "$USERDATA/VirtualMachines/containers/$ContainerName/disk/System/boot/partitions.hdp" ]]; then
    rm "$USERDATA/VirtualMachines/containers/$ContainerName/disk/System/boot/partitions.hdp"
fi

patch_os_mode() {
    local mode=$1
    if [[ "$mode" == "legacy" ]]; then
        local mode_version="1x"
    else
        local mode_version="2x"
    fi

    echo "Patching for $mode mode ($mode_version)..."
    cp "$OSSERVICES/Library/Virtualization/Patches/Partitions/Hermes${mode_version}.hdp" "$USERDATA/VirtualMachines/containers/$ContainerName/disk/System/boot/partinf.hdp"

    if [[ "$mode" == "legacy" ]]; then
        echo "true" > "$USERDATA/VirtualMachines/configs/$ContainerName/legacy"
    else
        rm "$USERDATA/VirtualMachines/configs/$ContainerName/legacy"
    fi
}

user_prompt() {
    echo -e "${YELLOW}It seems that the OS is upgraded from $1 mode to $2 mode.${NC}"
    echo -e "${YELLOW}If you want to use $1 mode, please press 1.${NC}"
    echo -e "${YELLOW}If you want to use $2 mode, please press 2.${NC}"
    read -r -n 1 -s

    case "$REPLY" in
        1)
            patch_os_mode "$1"
            ;;
        2)
            patch_os_mode "$2"
            ;;
        *)
            echo "Invalid input."
            exit 90
            ;;
    esac
}

legacy_flag="$USERDATA/VirtualMachines/configs/$ContainerName/legacy"
common_compatibility="$USERDATA/VirtualMachines/containers/$ContainerName/disk/System/sys/Default/registry/SYSTEM/Common/CommonCompatibility"

if [[ -f "$legacy_flag" ]]; then
    if [[ -f "$common_compatibility" ]]; then
        user_prompt "legacy" "normal"
    else
        patch_os_mode "legacy" "1x"
    fi
else
    if [[ ! -f "$common_compatibility" ]]; then
        user_prompt "normal" "legacy"
    else
        patch_os_mode "normal" "2x"
    fi
fi


sed "s|CONTAINER_NAME|$ContainerName|g" $USERDATA/VirtualMachines/containers/$ContainerName/disk/System/boot/partinf.hdp > $USERDATA/VirtualMachines/containers/$ContainerName/disk/System/boot/partitions.hdp
rm $USERDATA/VirtualMachines/containers/$ContainerName/disk/System/boot/partinf.hdp
echo "Partition map patched."

ORIG_BOOTARGS="$BOOTARGS"
unset BOOTARGS

if [[ "$Firmware" == "--firm" ]]; then
    echo "Launching using firmware..."
    cd "$USERDATA/VirtualMachines/containers/$ContainerName/disk/"
    "./System/boot/firm" "$Parameters"
else
    echo "Launching using default bootloader..."
    cd "$USERDATA/VirtualMachines/containers/$ContainerName/disk/"
    "./System/boot/init" "$Parameters"
fi

BOOTARGS="$ORIG_BOOTARGS"

cd "$currentWorkingDirectory"

echo "Container '$ContainerName' finished."
