#!/bin/bash
echo "Installed binaries:"
echo "___________________"
ls -1 "$SYSTEM/bin"
if [[ "$(mplxr USER/Shell/DeveloperOptions)" == "1" ]]; then
	ls -1 "$OSSERVICES/Library/Developer/bin"
fi
exit 0