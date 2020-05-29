#!/bin/bash
if [[ "$1" == "--nocopy" ]]; then
	echo "Logs will not be copied."
else
	cp -r "$CACHE/logs" "$DATA"
fi
rm -rf "$CACHE/logs"
