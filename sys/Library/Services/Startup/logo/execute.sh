#!/bin/bash
cat "$OSSERVICES/Library/Services/Startup/logo/logo_vbm.asimg"
if [[ -f "$OSSERVICES/Library/Services/Startup/sys_onStart.mp3" ]]; then
	afplay "$OSSERVICES/Library/Services/Startup/sys_onStart.mp3" &
fi