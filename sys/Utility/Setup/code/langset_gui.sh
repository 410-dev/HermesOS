#!/bin/bash
source "$BundlePath/code/languages_selectable"
export language="$("$SYSTEM/sys/Library/display" --stdout --radiolist "Select Language" 0 0 0 $langd)"
if [[ -z "$language" ]]; then
	echo "${SETUP_LANG_SELECTED}${LANG_ID}"
elif [[ -d "$SYSTEM/sys/Default/Languages/$language" ]]; then
	"$SYSTEM/sys/Library/display" --msgbox "${SETUP_SETTING_LANGUAGE}" 0 0
	cp "$SYSTEM/sys/Default/Languages/$language/"* "$LIBRARY/Preferences/Language/"
	source "$LIBRARY/Preferences/Language/system.hlang"
	"$SYSTEM/sys/Library/display" --msgbox "${SETUP_LANGUAGE_CHANGED}" 0 0
else
	echo "${NO_SUCH_LANGUAGE}"
fi
