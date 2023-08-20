#!/bin/bash
echo "Installed binaries:"
echo "___________________"
# ls -1 "$SYSTEM/man"
# if [[ "$(regread USER/Shell/DeveloperOptions)" == "1" ]]; then
# 	ls -1 "$OSSERVICES/Library/Developer/man"
# fi

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
	else
		ls -1 "$pth/man"
	fi
done

exit 0