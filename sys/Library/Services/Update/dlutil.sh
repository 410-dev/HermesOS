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
source "$CACHE/ota-profile"
if [[ ! -z "$OS_Version_Major" ]]; then
	if [[ ! -z "$(<"$(dirname "$0")/ota-address")" ]] && [[ ! -z "$(<"$(dirname "$0")/ota-filename")" ]]; then
		curl -L --progress-bar "$(<"$(dirname "$0")/ota-address")/$OS_Tag/$(<"$(dirname "$0")/ota-filename")" -o "$LIBRARY/image.zip"
		if [[ ! -z "$(cat "$LIBRARY/image.zip" | grep "sys/interface")" ]]; then
			echo "Download was successful: $OS_Tag"
			exit 0
		else
			echo "Failed downloading: $OS_Tag"
			rm "$LIBRARY/image.zip"
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