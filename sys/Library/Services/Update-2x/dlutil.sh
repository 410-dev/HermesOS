#!/bin/bash
if [[ -f "$LIBRARY/image.tar.gz" ]]; then
	echo "You already have an image downloaded."
	echo -n "Do you want to continue? (Y/n): "
	read yn
	if [[ "$yn" == "Y" ]] || [[ "$yn" == "y" ]]; then
		echo -n ""
	else
		echo "Aborted."
		exit 0
	fi
fi
echo "Checking tag..."
export URL="$(<"$(dirname "$0")/ota-profile")"
if [[ -f "$NVRAM/ota-profile" ]]; then
	export URL="$(<"$NVRAM/ota-profile")"
fi

curl -Ls "$URL" -o "$CACHE/ota-profile"
if [[ ! -z "$(cat "$CACHE/ota-profile" | grep "404:")" ]]; then
	echo "Compatible image not found. Unable to download image."
	exit 0
fi
SYSVER="$(cat "$CACHE/ota-profile")"
if [[ ! -z "$SYSVER" ]]; then
	if [[ ! -z "$(<"$(dirname "$0")/ota-address")" ]] && [[ ! -z "$(<"$(dirname "$0")/ota-filename")" ]]; then
		curl -L --progress-bar "$(<"$(dirname "$0")/ota-address")/$SYSVER/$(<"$(dirname "$0")/ota-filename")" -o "$LIBRARY/image.tar.gz"
		if [[ ! -z "$(file "$LIBRARY/image.tar.gz" | grep "gzip compressed data")" ]]; then
			echo "Download was successful: $SYSVER"
			exit 0
		else
			echo "Failed downloading: $SYSVER"
			rm "$LIBRARY/image.tar.gz"
			exit 0
		fi
	else
		echo "Internal ${ERROR}Address not found."
		exit 0
	fi
else
	echo "Compatible image not found. Unable to download image."
	exit 0
fi