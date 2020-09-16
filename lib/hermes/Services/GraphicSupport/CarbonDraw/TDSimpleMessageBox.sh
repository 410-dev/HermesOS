#!/bin/bash
"$(dirname "$0")/engine" --title "$1" --msgbox "$2" "$3" "$4"
exit $?