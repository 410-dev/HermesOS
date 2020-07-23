#!/bin/bash
if [[ -d "$LIB/crashlogs" ]]; then
	rm -rf "$LIB/crashlogs"
fi
if [[ -f "$LIB/boot_argument" ]]; then
	rm -f "$LIB/boot_argument"
fi
if [[ -f "$LIB/nvraminfo" ]]; then
	rm -f "$LIB/nvraminfo"
fi
exit 0