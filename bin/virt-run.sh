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
rm "$USERDATA/VirtualMachines/containers/$ContainerName/disk/System/boot/partitions.hdp"
if [[ -f "$USERDATA/VirtualMachines/configs/$ContainerName/legacy" ]]; then
    echo "Patching for legacy mode (1x)..."
    cp "$OSSERVICES/Library/Virtualization/Patches/Partitions/Hermes1x.hdp" "$USERDATA/VirtualMachines/containers/$ContainerName/disk/System/boot/partinf.hdp"
else
    echo "Patching for normal mode (2x)..."
    cp "$OSSERVICES/Library/Virtualization/Patches/Partitions/Hermes2x.hdp" "$USERDATA/VirtualMachines/containers/$ContainerName/disk/System/boot/partinf.hdp"
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
