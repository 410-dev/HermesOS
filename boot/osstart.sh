#!/bin/bash
export NULLVAR="null"
mkdir -p "$CACHE/SIG"
echo "[*] Running initiation script..."
"$SYSTEM/sbin/initsc"
if [[ -f "$CACHE/upgraded" ]]; then
	echo "System is upgraded. Stopping boot process."
	exit 9
fi
if [[ -f "$CACHE/init-load-failed" ]]; then
	echo "[!] Init returned non-zero exit code."
	exit 0
fi
"$SYSTEM/sbin/frameworks-loader"
if [[ -f "$CACHE/update-complete" ]]; then
	echo "[*] Update complete."
	rm -f "$CACHE/update-complete"
elif [[ -f "$CACHE/framework-load-failed" ]]; then
	echo "[!] Framworks loader returned non-zero exit code."
	ALIVE=$(ps -ax | grep "$SYSTEM/frameworks[/]")
	echo "$ALIVE" | while read proc
	do
		frpid=($proc)
		kill -9 ${frpid[0]}
		echo "[*] Killed: ${frpid[0]}"
	done
	exit 0
else
	echo "[*] Frameworks loaded without problem."
	echo "[*] Starting Interface..."
fi