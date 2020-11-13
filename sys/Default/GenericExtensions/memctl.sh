#!/bin/bash

function encrypt() {
	echo "$(md5 -qs "$1")"
}

function defineSpace() {
	if [[ ! -d "$CACHE/isolated_memory/$(encrypt "$1")" ]] && [[ ! -f "$CACHE/isolated_memory/$(encrypt "$1")" ]]; then
		mkdir -p "$CACHE/isolated_memory/$(encrypt "$1")"
	else
		echo "[MemAllocator] Failed defining isolated space: $1" >> "$CACHE/alert"
	fi
}

function defineData() {
	if [[ ! -f "$CACHE/isolated_memory/$(encrypt "$1")" ]]; then
		echo "$2" > "$(encrypt "$1")"
	else
		echo "[MemAllocator] Failed allocating memory: $1" >> "$CACHE/alert"
	fi
}

function clearSpace() {
	if [[ -d "$CACHE/isolated_memory/$(encrypt "$1")" ]]; then
		rm -rf "$CACHE/isolated_memory/$(encrypt "$1")"
	fi
}

function clearData() {
	if [[ -f "$CACHE/isolated_memory/$(encrypt "$1")" ]]; then
		rm -f "$CACHE/isolated_memory/$(encrypt "$1")"
	fi
}

function readData() {
	if [[ -f "$CACHE/isolated_memory/$(encrypt "$1")" ]]; then
		cat "$CACHE/isolated_memory/$(encrypt "$1")"
	fi
}

if [[ "$1" == "define" ]]; then
	if [[ "$2" == "space" ]]; then
		if [[ ! -z "$3" ]]; then
			defineSpace "$3"
		fi
	elif [[ "$2" == "data" ]]; then
		if [[ ! -z "$3" ]] && [[ ! -z "$4" ]]; then
			defineData "$3" "$4"
		fi
	fi
elif [[ "$1" == "clear" ]]; then
	if [[ "$2" == "space" ]]; then
		if [[ ! -z "$3" ]]; then
			clearSpace "$3"
		fi
	elif [[ "$2" == "data" ]]; then
		if [[ ! -z "$3" ]]; then
			clearData "$3"
		fi
	fi
elif [[ "$1" == "read" ]]; then
	if [[ ! -z "$2" ]]; then
		readData "$2"
	fi
fi
