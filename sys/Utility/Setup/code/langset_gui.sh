#!/bin/bash
source "$BundlePath/code/languages_selectable"
export language="$("$SYSTEM/sys/Library/display" --stdout --radiolist "Select Language" 0 0 0 $langd)"
if [[ -z "$language" ]]; then
	echo "You have selected: ${LANG_ID}"
elif [[ -d "$SYSTEM/sys/Default/Languages/$language" ]]; then
	echo "${SETTING_LANGUAGE}"
	rm -rf "$LIBRARY/Preferences/Language/system.hlang"
	cp "$SYSTEM/sys/Default/Languages/$language/"* "$LIBRARY/Preferences/Language/"
	source "$LIBRARY/Preferences/Language/system.hlang"
	echo "${LANGUAGE_CHANGED_ON_SETUP}"
else
	echo "No such language."
fi
