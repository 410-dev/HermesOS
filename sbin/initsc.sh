#!/bin/bash
export NULLVAR="null"
currentDir="$PWD"
action="$1"
Data="$LIB/Logs"
sys="$SYSTEM/init"
cached="$CACHE/init"
mkdir -p "$Data"
echo "[*] Reading initsc loading priority..."
exitCode=0
logDate=$(date +"%Y-%m-%d_%H-%M")
while [[ true ]]; do
	if [[ -f "$sys/LoadOrder" ]]; then
		cat "$sys/LoadOrder" | while read line
		do
			if [[ -d "$currentDir/cache/def" ]]; then
				cd "$currentDir/cache/def"
				for file in *.def
				do
					source "$file"
				done
			fi
			cd "$sys"
			SelectedFramework="$line"
			if [[ -d "$line" ]]; then
				ID=$(<"$SelectedFramework"/identifier)
				echo "[*] Loading $ID..."
				mkdir -p "$cached/$ID"
				cd $ROOTFS
				echo "[$(date +"%Y-%m-%d %H:%M")] RUN: $ID" >> "$Data/INIT_$logDate.tlog"
				"$sys/$SelectedFramework"/exec "$sys/$SelectedFramework" "$cached/$ID" | tee -a "$Data/INIT_$logDate.tlog"
				ec=$?
				echo "END: $ID" >> "$Data/INIT_$logDate.tlog"
				echo "EXIT: $ec" >> "$Data/INIT_$logDate.tlog"
				if [[ $ec == 0 ]]; then
					echo "[*] Load complete."
				else
					echo "[!] An error occured while loading $ID."
					touch "$CACHE/load-failed"
				fi
			else
				echo "[!] Not existing init file: $line"
				echo "[!] Skipped."
			fi
		done
		break
	else
		echo "[!] InitSC priority not found at: $sys/LoadOrder"
		sleep 5
	fi
done
echo "[*] Initsc task finished."
cd "$currentDir"