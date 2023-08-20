#!/bin/bash
if [[ -z "$1" ]]; then
	echo "${MISSING_PARAM}command"
	exit 90
fi

SEARCHPATHS2="$(regread "SYSTEM/Path")"
if [[ ! -z "$SEARCHPATHS2" ]] && [[ "$SEARCHPATHS2" != "null" ]] && [[ "$SEARCHPATHS2" != "default" ]] && [[ "$SEARCHPATHS2" != "null" ]]; then
	export SEARCHPATHS="$SEARCHPATHS2"
else
	regwrite "SYSTEM/Path" "$SEARCHPATHS" > /dev/null
fi

IFS=':' read -ra ListOfPath <<< "$SEARCHPATHS"
FOUND=0
for pth in "${ListOfPath[@]}"; do
	pth="$ROOTFS$pth"
	if [[ ! -d "$pth/man" ]]; then
		continue
	fi
	if [[ -f "$pth/man/$1" ]]; then
		cat "$pth/man/$1"
		FOUND=1
	fi
done

if [[ "$FOUND" -eq "0" ]]; then
	echo "No manual avaliable: $1"
fi

exit 0