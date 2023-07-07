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

if [[ ! -d "$USERDATA/VirtualMachines/containers" ]]; then
    echo "No containers found."
    exit 90
fi

ls -1 "$USERDATA/VirtualMachines/containers" | while read -r line; do
    if [[ -d "$USERDATA/VirtualMachines/containers/$line" ]]; then
        echo "$line"
    fi
done
