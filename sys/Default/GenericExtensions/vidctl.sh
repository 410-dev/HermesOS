#!/bin/bash
if [[ "$1" == "clearScreen" ]]; then
	clear
elif [[ "$1" == "addLine" ]]; then
	echo "$2"
fi