#!/bin/bash
if [[ -f "$NVRAM/upgraded" ]]; then
	exit 0
else
	echo "[*] Running frameworks asyncronously..."
	mkdir -p "$CACHE/frameworks"
	FrameworkLibrary="$SYSTEM/frameworks"
	cached="$CACHE/frameworks"
	echo "[*] Reading frameworks loading priority..."
	while [[ true ]]; do
		if [[ -f "$FrameworkLibrary/LoadOrder" ]]; then
			cat "$FrameworkLibrary/LoadOrder" | while read line
			do
				cd "$FrameworkLibrary"
				SelectedFramework="$line"
				if [[ -d "$line" ]]; then
					ID=$(<"$SelectedFramework"/identifier)
					echo "[*] Loading $ID..."
					mkdir -p "$cached/$ID"
					cd "$ROOTFS"
					if [[ -z "$(echo "$b_arg" | grep "frameworknoerror")" ]]; then
						"$FrameworkLibrary/$SelectedFramework"/exec "$FrameworkLibrary/$SelectedFramework" "$cached/$ID" & >/dev/null
						ec=$?
					else
						"$FrameworkLibrary/$SelectedFramework"/exec "$FrameworkLibrary/$SelectedFramework" "$cached/$ID" & >/dev/null 2>/dev/null
						ec=$?
					fi
					if [[ $ec == 0 ]]; then
						echo "[*] Load complete."
					else
						echo "[!] An error occured while loading $ID."
						touch "$CACHE/framework-load-failed"
						exit
					fi
				else
					echo "[!] Not existing framwork: $line"
					echo "[!] Skipped."
				fi
			done
			break
		else
			echo "[!] Frameworks priority not found at: $FrameworkLibrary/LoadOrder"
			sleep 5
		fi
	done
	exit 0
fi