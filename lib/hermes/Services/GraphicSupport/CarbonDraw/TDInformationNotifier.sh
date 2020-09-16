#!/bin/bash
"$(dirname "$0")/engine" --infobox "$1" "$2" "$3"
exit $?