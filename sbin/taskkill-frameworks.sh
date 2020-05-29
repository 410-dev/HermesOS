#!/bin/bash
if [[ "$1" == "verbose" ]]; then
	echo "[*] Loading lists of alive frameworks..."
	ALIVE=$(ps -ax | grep "$SYSTEM/frameworks[/]")
	echo "[*] Currently $(echo "$ALIVE" | wc -l) frameworks are up and running."
	echo "[*] Killing asyncronously..."
	echo "$ALIVE" | while read proc
	do
		frpid=($proc)
		kill -9 ${frpid[0]}
		echo "[*] Killed PID: ${frpid[0]}"
	done
	echo "[*] Frameworks are closed."
else
	ALIVE=$(ps -ax | grep "$SYSTEM/frameworks[/]")
	echo "$ALIVE" | while read proc
	do
		frpid=($proc)
		kill -9 ${frpid[0]}
	done
fi