#!/bin/bash
"$(dirname "$0")/TDGraphicalUIRenderer" --title "$1" --msgbox "$2" 0 0
exit $?