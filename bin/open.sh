#!/bin/bash

if [[ -z "$1" ]]; then
	echo "${MISSING_PARAM}app name"
	exit
fi

if [[ -f "$USERDATA/$1" ]]; then
	echo "Unpacking..."
	mkdir -p "$CACHE/pkgunpack"
	mv "$USERDATA/$1" "$CACHE/package.zip"
	unzip -q "$CACHE/package.zip" -d "$CACHE/pkgunpack"
	source "$CACHE/pkgunpack/INFO"
	cp -r "$CACHE/pkgunpack" "$DATA/Applications/"
	mv "$DATA/Applications/pkgunpack" "$DATA/Applications/$APPNAME"
	rm -f "$CACHE/package.zip"
	echo "Installation successful."
elif [[ -d "$DATA/Applications/$1" ]]; then
	if [[ -f "$DATA/Applications/$1/runner" ]]; then
		if [[ ! -f "$DATA/Applications/$1/INFO" ]]; then
			echo "Unable to execute application: INFO is missing."
			exit
		fi
		source "$DATA/Applications/$1/INFO"
		if [[ "$BUILTFOR" == "$SDK_COMPATIBILITY" ]] || [[ $(bootArgumentHas "ignore_sdk_compatibility") == 1 ]] || [[ "$BUILTFOR" == "all" ]]; then
			chmod +x "$DATA/Applications/$1/runner"
			if [[ "$ALLOCTHREAD" == "backgroundservice" ]]; then
				"$DATA/Applications/$1/runner" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" &
				echo "Background Service launched."
			else
				"$DATA/Applications/$1/runner" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
				exit $?
			fi
		else
			echo "Application is incompatible."
		fi
	else
		echo "Unable to execute application: Runner is missing."
		exit
	fi
else
	echo "Application not found."
fi