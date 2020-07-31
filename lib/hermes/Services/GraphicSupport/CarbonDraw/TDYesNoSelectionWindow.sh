#!/bin/bash
"$(dirname "$0")/engine" --title "$1" --yesno "$2" 0 0
echo $?