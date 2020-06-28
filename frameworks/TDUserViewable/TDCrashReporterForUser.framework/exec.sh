#!/bin/bash
while [[ true ]]; do
	sleep 3
	logDate=$(date +"%Y-%m-%d-%H:%M")
	if [[ -d "$CACHE/logs" ]]; then
		cd "$CACHE/logs"
		if [[ ! -z $(ls | grep "panic-") ]]; then
			for f in panic-*; do
				echo ""
				echo "==========!ALERT!==========="
				echo "Fatal error!"
				echo "===========|INFO|==========="
				echo "Type: Panic"
				echo "LOG: $f"
				echo "===========|LOG|============"
				cat "$f"
				echo "===========|END|============"
				echo ""
				mv ./processed/"$f" ./processed/"$f($logDate)"
				cp "$f" ./processed/
				rm "$f"
			done
		fi
		if [[ ! -z $(ls | grep "crash-") ]]; then
			for f in crash-*; do
				echo ""
				echo "==========!ALERT!==========="
				echo "Fatal error!"
				echo "===========|INFO|==========="
				echo "Type: Crash"
				echo "LOG: $f"
				echo "===========|LOG|============"
				cat "$f"
				echo "===========|END|============"
				cp "$f" ./processed/
				mv ./processed/"$f" ./processed/"$f($logDate)"
				rm "$f"
			done
		fi
	fi
	cd "$ROOTFS"
	if [[ -d "$DATA/logs" ]]; then
		cd "$DATA/logs"
		if [[ ! -z $(ls | grep "panic-") ]]; then
			for f in panic-*; do
				echo ""
				echo "==========!ALERT!==========="
				echo "Fatal error!"
				echo "===========|INFO|==========="
				echo "Type: Panic"
				echo "LOG: $f"
				echo "===========|LOG|============"
				cat "$f"
				echo "===========|END|============"
				echo ""
				cp "$f" ./processed/
				mv ./processed/"$f" ./processed/"$f($logDate)"
				rm "$f"
			done
		fi
		if [[ ! -z $(ls | grep "crash-") ]]; then
			for f in crash-*; do
				echo ""
				echo "==========!ALERT!==========="
				echo "Fatal error!"
				echo "===========|INFO|==========="
				echo "Type: Crash"
				echo "LOG: $f"
				echo "===========|LOG|============"
				cat "$f"
				echo "===========|END|============"
				cp "$f" ./processed/
				mv ./processed/"$f" ./processed/"$f($logDate)"
				rm "$f"
			done
		fi
	fi
	cd "$ROOTFS"
done