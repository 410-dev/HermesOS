#!/bin/bash
if [[ -f "$DATA/nvcache/upgraded" ]]; then
	exit 0
else
	echo "[*] Running frameworks asyncronously..."
	mkdir -p "$CACHE/frameworks"
	Data="$DATA/logs"
	FrameworkLibrary="$SYSTEM/frameworks"
	cached="$CACHE/frameworks"
	mkdir -p "$Data"
	echo "[*] Reading frameworks loading priority..."
	exitCode=0
	logDate=$(date +"%Y-%m-%d-%H:%M")
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
					echo "LOAD: $ID" >> "$Data/output-frameworkloader-$logDate"
					"$FrameworkLibrary/$SelectedFramework"/exec "$FrameworkLibrary/$SelectedFramework" "$cached/$ID" & >> "$Data/output-frameworkloader-$logDate" >/dev/null
					ec=$?
					if [[ $ec == 0 ]]; then
						echo "[*] Load complete."
					else
						echo "[!] An error occured while loading $ID."
						touch "$CACHE/load-failed"
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
	exit $exitCode
fi