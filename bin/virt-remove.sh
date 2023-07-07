#!/bin/bash

# Check if virtualizable
if [[ "$(bootArgumentHas "vm.nested=0")" == 1 ]]; then
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

if [[ ! -d "$USERDATA/VirtualMachines/containers/$1" ]]; then
    echo "Container does not exist."
    exit 90
fi

rm -rf "$USERDATA/VirtualMachines/containers/$1" >/dev/null 2>&1
rm -rf "$USERDATA/VirtualMachines/configs/$1" >/dev/null 2>&1

echo "Container '$1' removed."
