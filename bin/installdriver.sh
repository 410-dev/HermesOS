#!/bin/bash

if [[ "$HUID" -ne 0 ]]; then
    echo "Permission denied: $HUID"
    exit 0
fi

if [[ -f "$USERDATA/$1" ]]; then
    if [[ "$(accessible "r" "$USERDATA/$1")" -ne 0 ]]; then
        echo "Access denied: Operation not permitted."
        exit 99
    fi
    echo "Installing package..."
    unzip -o -q "$USERDATA/$1" -d "$LIBRARY/HardwareExtensions"
    rm -rf "$LIBRARY/HardwareExtensions/__MACOSX"
    echo "Done."
else
    echo "File not found."
fi