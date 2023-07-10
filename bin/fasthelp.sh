#!/bin/bash
echo "Installed binaries:"
echo "___________________"
ls -1 "$SYSTEM/man"
if [[ "$(regread USER/Shell/DeveloperOptions)" == "1" ]]; then
	ls -1 "$OSSERVICES/Library/Developer/man"
fi
exit 0