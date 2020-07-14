#!/bin/bash
echo "[*] Reading initsc loading order..."
if [[ "$(mplxr USER/INIT/ORDER)" == "0" ]]; then
	echo "[*] Nothing installed."
else
	if [[ -z "$($b_args | grep "safemode")" ]]; then
		if [[ "$(mplxr USER/INIT/ORDER)" == "null" ]]; then
			echo "[!] InitSC priority not found in multiplex."
		else
			echo "$(mplxr USER/INIT/ORDER)" | while read line
			do
				cd "$DATA/init"
				SelectedFramework="$line"
				if [[ -d "$line" ]]; then
					ID=$(<"$SelectedFramework"/identifier)
					echo "[*] Loading $ID..."
					mkdir -p "$CACHE/init/$ID"
					cd "$ROOTFS"
					"$DATA/init/$SelectedFramework"/exec "$DATA/init/$SelectedFramework"
					if [[ $? == 0 ]]; then
						echo "[*] Load complete."
					else
						echo "[!] An error occured while loading $ID."
					fi
				else
					echo "[!] Not existing init file: $line"
					echo "[!] Skipped."
				fi
			done
		fi
	else
		echo "[-] Safe mode enabled."
	fi
fi
echo "[*] Initsc task finished."
exit 0