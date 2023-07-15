#!/bin/bash
echo "WARNING: Legacy OTA downloading feature will be removed in a future release."
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

URL="$(regread "SYSTEM/Update/LegacyImageURL")"
if [[ -z "$URL" ]] || [[ "$URL" == "null" ]]; then
	URL="https://github.com/410-dev/HermesOS/releases/download/15.1/image.zip"
fi

curl -L --progress-bar "$URL" -o "$LIBRARY/image.zip"
if [[ ! -z "$(cat "$LIBRARY/image.zip" | grep "sys/interface")" ]]; then
	echo "Download was successful."
	exit 0
else
	echo "Failed downloading legacy image. (Unable to verify)"
	rm "$LIBRARY/image.zip"
	exit 0
fi