#!/bin/bash
if [[ -f "$LIBRARY/image.zip" ]]; then
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
curl -Ls "$URL" -o "$CACHE/ota-profile"
source "$CACHE/ota-profile"
if [[ ! -z "$(<"$(dirname "$0")/ota-address")" ]] && [[ ! -z "$(<"$(dirname "$0")/ota-address")" ]]; then
	curl -L --progress-bar "$(<"$(dirname "$0")/ota-address")/$OS_Tag/$(<"$(dirname "$0")/ota-filename")" -o "$LIBRARY/image.zip"
	if [[ ! -z "$(cat "$LIBRARY/image.zip" | grep "lib/hermes")" ]]; then
		echo "Download was successful: $OS_Tag"
		exit 0
	else
		echo "Failed downloading: $OS_Tag"
		rm "$LIBRARY/image.zip"
		exit 0
	fi
else
	echo "Internal Error: Address not found."
	exit 0
fi