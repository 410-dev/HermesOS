#!/bin/bash
while [[ true ]]; do
	sleep 3
	if [[ ! -d "$CACHE/logs/processed" ]]; then
		mkdir -p "$CACHE/logs/processed"
	fi
    if [[ ! -d "$DATA/logs/processed" ]]; then
		mkdir -p "$DATA/logs/processed"
	fi
done
exit 0