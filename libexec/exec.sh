#!/bin/bash
if [[ -f "$USERDATA/$1" ]]; then
	if [[ ! -z "$(echo "$b_args" | grep "verbose")" ]]; then
		echo "[*] Verifying..."
	fi
	cat "$USERDATA/$1" | while read fileLine
	do
		cat "$CACHE/init/TouchDown.Security.ExecutableQuarantine/disabledContents" | while read disabledCommand
		do
			if [[ $(echo "$fileLine") ==  "$disabledCommand "* ]]; then
				echo "Execution disabled by sandbox."
				cd "$DATA"
				exit 9
			elif [[ $(echo "$fileLine") ==  "libexec $disabledCommand "* ]]; then
				echo "[Warning] This application will access to libexec."
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