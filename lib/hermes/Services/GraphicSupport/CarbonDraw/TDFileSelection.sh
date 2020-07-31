#!/bin/bash
echo $("$(dirname "$0")/engine" --stdout --title "$1" --fselect "$2" 0 0)