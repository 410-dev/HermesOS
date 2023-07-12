#!/bin/bash

source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/internal_func"
source "$(dirname "$0")/bootloader/osstart"

ORIG_BOOT_ARGS="$@"

function FIRMWARE_INFO() {
    if [[ "$1" == "version" ]]; then
        echo "LiteFirm 1.2"
    elif [[ "$1" == "vendor" ]]; then
        echo "410"
    elif [[ "$1" == "virtualization" ]]; then
        echo "1"
    elif [[ "$1" == "unload" ]]; then
        echo "1"
    elif [[ "$1" == "instruction" ]]; then
        if [[ ! -z "$2" ]]; then
            if [[ ! -z "$(which "$2")" ]]; then
                echo "1"
            else
                echo "0"
            fi
        else
            echo "0"
        fi
    else
        echo "0"
    fi
}

trap sysreset INT
function sysreset() {
	echo ""
	clear
	sys_log "Firmware" "Device reset!!"
    echo "[System Event] Resetting device..."
    sleep 1
    rm -rf "$CACHE"
    "$CORE/osstop"
    "$(dirname "$0")/firm" "$ORIG_BOOT_ARGS"
}


function FIRMWARE() {
    if [[ "$1" == "unload" ]]; then
        trap - INT
        unset -f sysreset
        unset -f FIRMWARE_INFO
        echo "0"
    else
        echo "1"
    fi
}

export -f FIRMWARE_INFO
export -f FIRMWARE

"$(dirname "$0")/init" "$@"
