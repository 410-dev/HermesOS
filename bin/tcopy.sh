#!/bin/bash
if [[ -f "$USERDATA/$1" ]]; then
	export d="$(cat "$USERDATA/$1")"
	"$MEM_CTL" define data tempcopy "$d"
	unset d
else
	"$MEM_CTL" define data tempcopy "$1"
fi
