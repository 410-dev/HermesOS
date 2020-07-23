#!/bin/bash
echo $("$(dirname "$0")/TDGraphicalUIRenderer" --stdout --title "$1" --fselect "$2" 0 0)