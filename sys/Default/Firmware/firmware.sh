#!/bin/bash
function FIRMWARE_INFO() {
	if [[ "$1" == "version" ]]; then
		echo "0.01"
	elif [[ "$1" == "manufacture" ]]; then
		echo "410"
	else
		echo "Version: 0.01"
		echo "Manufacture: 410"
	fi
}


export -f FIRMWARE_INFO