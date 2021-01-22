#!/bin/bash

if [[ "$HUID" -ne 0 ]]; then
    echo "${PERMISSION_DENIED}$HUID"
    exit 0
fi

if [[ -f "$USERDATA/$1" ]]; then
    if [[ "$(access_fs "$USERDATA/$1")" -ne 0 ]]; then
        echo "${OPERATION_NOT_PERMITTED}Read File"
        exit 99
    fi
    echo "Installing package..."
    unzip -o -q "$USERDATA/$1" -d "$LIBRARY/HardwareExtensions"
    rm -rf "$LIBRARY/HardwareExtensions/__MACOSX"
    echo "${DONE}"
else
    echo "${NO_SUCH_FILE}$1"
fi