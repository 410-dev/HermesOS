#!/bin/bash

if [[ ! -f "$LIBRARY/Developer/ZLang/zlang-linker" ]]; then
	echo "ZLang is not installed."
	exit 1
fi
source "$LIBRARY/Developer/ZLang/zlang-linker" "$LIBRARY/Developer/ZLang"
export ZLANG_SUPPRESS_WARNING=1
if [[ "$1" == "--version" ]]; then
	echo "Interpreter Version: 2.0"
	exit 0
elif [[ -f "$PWD/$1" ]]; then
	if [[ $(bootArgumentHas "verbose") == 1 ]]; then
		echo "[*] Verifying..."
	fi
	cat "$PWD/$1" | while read fileLine
	do
		echo "$QuarantineData" | while read disabledCommand
		do
			if [[ $(echo "$fileLine") ==  "$disabledCommand "* ]] && [[ "$OS_ProSystemStatus" == "Default" ]]; then
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
		if [[ $(bootArgumentHas "verbose") == 1 ]]; then
			echo "[*] Verification complete."
		fi
		cd "$PWD"
		CMD="$PWD/$1"
		shift
		"$CMD" "$@"
		exitcode=$?
		cd "$DATA"
		exit $exitcode
	fi
else
	echo "${NO_SUCH_FILE}Type=Executable"
fi
cd "$DATA"