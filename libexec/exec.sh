#!/bin/bash
if [[ -f "$USERDATA/$1" ]]; then
	echo "Verifying..."
	cat "$USERDATA/$1" | while read fileLine
	do
		cat "$CACHE/init/TouchDown.Security.ExecutableQuarantine/disabledContents" | while read disabledCommand
		do
			if [[ $(echo "$fileLine") ==  *"$disabledCommand"* ]]; then
				echo "Execution disabled by sandbox."
				cd "$DATA"
				exit 9
			elif [[ $(echo "$fileLine") ==  "$disabledCommand"* ]]; then
				echo "Execution disabled by sandbox."
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
		echo "Verification complete."
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