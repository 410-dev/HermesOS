#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Error: location not specified!"
	exit
elif [[ -d "$USERDATA/$1" ]]; then
	echo "Directory already exists."
	exit
fi

mkdir -p "$USERDATA/$1/code"
if [[ -d "$USERDATA/$1" ]]; then
	export INFO="export APPNAME=\"\"
export APPVERSION=\"1.0\"
export APPBUILD=\"1\"
export FRAMEWORKS=\"org.hermesapi.Foundation\"
export ALLOCTHREAD=\"main\"
"
	echo "$INFO" > "$USERDATA/$1/INFO"
	echo \#\!/bin/bash > "$USERDATA/$1/code/main"
else
	rm -rf "$USERDATA/$1"
	echo "Unable to open project: Unaccessible location"
fi