#!/bin/bash
if [[ -f "$NVRAM/frestrictor_config" ]]; then
	if [[ ! -z "$(echo "$NVRAM/frestrictor_config" | grep "--full-disable")" ]]; then
		exit 0
	fi
fi

if [[ "$1" == "set-alert" ]]; then
	if [[ ! -z "$2" ]]; then
		echo "$2" >> "$CACHE/alert"
		exit 0
	fi
elif [[ "$1" == "verify" ]]; then
	if [[ -z "$2" ]]; then
		exit 9
	elif [[ -f "$NVRAM/security/frestrictor_trustedagents/$2" ]]; then
		exit 0
	else
		exit 9
	fi
else
	exit 9
fi

exit 9