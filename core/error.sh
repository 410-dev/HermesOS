#!/bin/bash
function error() {
	echo "😵"
	verbose "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
	exit 120
}
