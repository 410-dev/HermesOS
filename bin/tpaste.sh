#!/bin/bash
if [[ ! -z "$1" ]]; then
	export copyd="$("$MEM_CTL" read tempcopy)"
	echo "$copyd" > "$USERDATA/$1"
else
	"$MEM_CTL" read tempcopy
fi