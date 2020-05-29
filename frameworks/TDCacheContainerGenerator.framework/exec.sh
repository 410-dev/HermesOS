#!/bin/bash
while [[ true ]]; do
	sleep 3
	if [[ ! -d "$CACHE/SIG" ]]; then
		mkdir -p "$CACHE/SIG"
	fi
done