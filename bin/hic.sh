#!/bin/bash

if [[ "$HUID" -ne 0 ]]; then
	echo "${PERMISSION_DENIED}$HUID"
	exit 0
fi


source "$OSSERVICES/Library/Developer/System.iskit"
function internal_exec() {
	cat "$1" | while read fileLine
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
		cd "$USERDATA"
		"$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
	fi
}

if [[ -f "$NVRAM/enable_dev_option" ]] || [[ "$OS_UnlockedDistro" == "Unlocked" ]]; then
	mkdir -p "$CACHE/tdinterpreter"
	if [[ -z "$1" ]]; then
		println "Hermes Interpreter Interactive Console"
		println "Type ISA.manual to see available commands. To stop, type exit."
		println "System.iskit is automatically imported."
		while [[ true ]]; do
			echo -n "\$ "
			read command
			if [[ $command == "exit" ]]; then
				break
			elif [[ ! -z "$(echo "$command" | grep "@IMPORT")" ]]; then
				parse=($command)
				if [[ -f "$OSSERVICES/Library/Developer/${parse[1]}.iskit" ]]; then
					source "$OSSERVICES/Library/Developer/${parse[1]}.iskit"
				elif [[ -f "$LIBRARY/Developer/${parse[1]}.iskit" ]]; then
					source "$LIBRARY/Developer/${parse[1]}.iskit"
				else
					echo "${ERROR}Unable to find specified instruction set."
					exit 0
				fi
			elif [[ ! -z "$(echo "$command" | grep "@IMPORT_ISA")" ]]; then
				parse=($command)
				if [[ -f "$OSSERVICES/Services/LegacySupport/TDAPI/VirtualISAKit-v${command[1]}.iskit" ]]; then
					source "$OSSERVICES/Services/LegacySupport/TDAPI/VirtualISAKit-v${command[1]}.iskit"
				else
					echo "${ERROR}Instruction Kit $command does not exist in LegacySupport."
					exit 0
				fi
			elif [[ ! -z $command ]]; then
				echo "@PROG_RUNNABLE" > "$CACHE/tdinterpreter/cmd"
				echo "$command" >> "$CACHE/tdinterpreter/cmd"
				chmod +x "$CACHE/tdinterpreter/cmd"
				internal_exec "$CACHE/tdinterpreter/cmd"
			fi
		done
	else
		echo "@PROG_RUNNABLE" > "$CACHE/tdinterpreter/cmd"
		echo "$1" >> "$CACHE/tdinterpreter/cmd"
		chmod +x "$CACHE/tdinterpreter/cmd"
		internal_exec "$CACHE/tdinterpreter/cmd"
	fi
else
	echo "Launching Interactive Interpreter Console failed."
	exit 0
fi