#!/bin/bash
if [[ "$1" == "--version" ]]; then
	echo "Interpreter Version: 1.0.1"
	exit 0
elif [[ -f "$USERDATA/$1" ]]; then
	if [[ ! -z "$(echo "$b_args" | grep "verbose")" ]]; then
		echo "[*] Verifying..."
	fi
	if [[ -z "$(cat "$USERDATA/$1" | grep "@PROG_START_POINT")" ]]; then
		echo "Unable to start program: Unable to find @PROG_START_POINT"
		exit 9
	fi
	cat "$USERDATA/$1" | while read fileLine
	do
		echo "$QuarantineData" | while read disabledCommand
		do
			if [[ $(echo "$fileLine") ==  "$disabledCommand "* ]]; then
				echo "Execution disabled by sandbox."
				cd "$DATA"
				exit 9
			elif [[ $(echo "$fileLine") ==  "bin $disabledCommand "* ]]; then
				echo "[Warning] This application will access to bin."
				cd "$DATA"
				exit 9
			fi
			exitc=$?
			if [[ $exitc == 9 ]]; then
				exit 9
			fi
		done
		exitc=$?
		if [[ $exitc == 9 ]]; then
			exit 9
		fi
	done
	exitc=$?
	if [[ $exitc == 0 ]]; then
		if [[ ! -z "$(echo "$b_args" | grep "verbose")" ]]; then
			echo "[*] Verification complete."
		fi
		cd "$USERDATA"
		"$USERDATA/$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
		exitcode=$?
		cd "$DATA"
		exit $exitcode
	fi
else
	echo "Executable file not found."
fi
cd "$DATA"