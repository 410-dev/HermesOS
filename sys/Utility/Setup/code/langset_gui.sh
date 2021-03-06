#!/bin/bash
sys_log "Setup" "Setting languages..."
source "$BundlePath/code/languages_selectable"
export language="$("$OSSERVICES/Library/display" --stdout --radiolist "Select Language" 0 0 0 $langd)"
if [[ -z "$language" ]]; then
	echo "${SETUP_LANG_SELECTED}${LANG_ID}"
elif [[ -d "$OSSERVICES/Default/Languages/$language" ]]; then
	"$OSSERVICES/Library/display" --infobox "${SETUP_SETTING_LANGUAGE}" 0 0
	cp "$OSSERVICES/Default/Languages/$language/"* "$LIBRARY/Preferences/Language/"
	source "$LIBRARY/Preferences/Language/setup.hlang"
	"$OSSERVICES/Library/display" --msgbox "${SETUP_LANGUAGE_CHANGED}" 0 0
	sys_log "Setup" "Language set: ${LANG_ID}"
else
	sys_log "Setup" "Invalid language setup."
	echo "${NO_SUCH_LANGUAGE}"
fi
