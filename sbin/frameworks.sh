#!/bin/bash
action="$1"
Data="$DATA/logs"
sys="$SYSTEM/frameworks"
cached="$CACHE/frameworks"
mkdir -p "$Data"
if [[ $action == "--load" ]]; then
	echo "[*] Reading frameworks loading priority..."
	exitCode=0
	logDate=$(date +"%Y-%m-%d-%H:%M")
	while [[ true ]]; do
		if [[ -f "$sys/priority" ]]; then
			cat "$sys/priority" | while read line
			do
				cd "$sys"
				SelectedFramework="$line"
				if [[ -d "$line" ]]; then
					ID=$(<"$SelectedFramework"/identifier)
					echo "[*] Loading $ID..."
					mkdir -p "$cached/$ID"
					cd /Volumes/VFS
					echo "LOAD: $ID" >> "$Data/output-frameworkloader-$logDate"
					"$sys/$SelectedFramework"/exec "$sys/$SelectedFramework" "$cached/$ID" & >> "$Data/output-frameworkloader-$logDate" >/dev/null
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
			echo "[!] Frameworks priority not found at: $sys/priority"
			sleep 5
		fi
	done
	exit $exitCode
fi
