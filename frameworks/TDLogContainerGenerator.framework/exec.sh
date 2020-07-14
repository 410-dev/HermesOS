#!/bin/bash
while [[ true ]]; do
	sleep 5
    if [[ ! -d "$DATA/Library/Logs" ]]; then
		mkdir -p "$DATA/Library/Logs"
	fi
done
exit 0