#!/bin/bash
USERSHA="$("$XGuardLibPath/lib/cryptograph" "$1")"
if [[ -f "$LIBRARY/LoginData/$USERSHA" ]]; then
	"$LIBRARY/LoginData/"