#!/bin/bash
"$(dirname "$0")/TDGraphicalUIRenderer" --title "$1" --yesno "$2" 0 0
echo $?