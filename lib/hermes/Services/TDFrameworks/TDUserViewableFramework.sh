#!/bin/bash
action="$1"
Data="$LIB/Logs"
sys="$SYSTEM/frameworks/TDUserViewable"
cached="$CACHE/nohidden-frameworks/"
mkdir -p "$Data"
echo "[*] Reading frameworks loading priority..."
exitCode=0
logDate=$(date +"%Y-%m-%d-%H:%M")
while [[ true ]]; do
	if [[ -f "$sys/LoadOrder" ]]; then
		cat "$sys/LoadOrder" | while read line
		do
			cd "$sys"
			SelectedFramework="$line"
			if [[ -d "$line" ]]; then
				ID=$(<"$SelectedFramework"/identifier)
				echo "[*] Loading $ID..."
				mkdir -p "$cached/$ID"
				cd "$ROOTFS"
				"$sys/$SelectedFramework"/exec "$sys/$SelectedFramework" "$cached/$ID" &
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
		echo "[!] Frameworks loading order configuration not found at: $sys/LoadOrder"
		sleep 5
	fi
done
echo "[*] Finished loading viewable frameworks."
exit $exitCode