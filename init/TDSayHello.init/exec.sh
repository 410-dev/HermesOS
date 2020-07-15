#!/bin/bash
if [[ -f "$CACHE/alert" ]]; then
	if [[ -z "$(cat "$CACHE/alert" | grep "TouchDownOS User Executive")" ]]; then
		echo "TouchDownOS User Executive" >> "$CACHE/alert"
	fi
else
	echo "TouchDownOS User Executive" >> "$CACHE/alert"
fi
exit 0