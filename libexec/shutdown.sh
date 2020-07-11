#!/bin/bash
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	echo "[*] Terminating background frameworks..."
	"$SYSTEM/sbin/taskkill-frameworks" "verbose"
	if [[ "$1" == "--nologcopy" ]]; then
		echo "[*] Logs will not be copied."
	else
		echo "[*] Saving logs..."
		cp -r "$CACHE/logs" "$DATA"
	fi
	if [[ "$(mplxr "SYSTEM/POLICY/isUsingImg")" == "TRUE" ]]; then
		echo "[*] Detaching data partition from root filesystem..."
		hdiutil detach "$DATA" -force >/dev/null
	fi
	echo "[*] Requesting shell to close..."
	touch "$CACHE/SIG/shell_close"
	echo "[*] Requesting kernel to close..."
	touch "$CACHE/SIG/kernel_close"
	echo "[*] Pre-shutdown process complete..."
	exit 0
else
	"$SYSTEM/sbin/taskkill-frameworks"
	if [[ "$1" -ne "--nologcopy" ]]; then
		cp -r "$CACHE/logs" "$DATA"
	fi
	if [[ "$(mplxr "SYSTEM/POLICY/isUsingImg")" == "TRUE" ]]; then
		hdiutil detach "$DATA" -force >/dev/null
	fi
	touch "$CACHE/SIG/shell_close"
	touch "$CACHE/SIG/kernel_close"
	exit 0
fi