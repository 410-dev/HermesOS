#!/bin/bash
if [[ ! -z "$(echo $b_args | grep "iamdeveloper")" ]] && [[ -f "$NVRAM/enable_dev_option" ]]; then
	mkdir -p "$CACHE/tdinterpreter"
	if [[ -z "$1" ]]; then
		println "TouchDownOS Interpreter Interactive Console"
		println "Type TouchDownAPI.manual to see available commands. To stop, type exit."
		while [[ true ]]; do
			echo -n "\$ "
			read command
			if [[ $command == "exit" ]]; then
				break
			elif [[ ! -z "$(echo "$command" | grep "@IMPORT")" ]]; then
				parse=($command)
				if [[ -f "$TDLIB/Library/Developer/${parse[1]}.tis" ]]; then
					source "$TDLIB/Library/Developer/${parse[1]}.tis"
				elif [[ -f "$DATA/Library/Developer/${parse[1]}.tis" ]]; then
					source "$DATA/Library/Developer/${parse[1]}.tis"
				else
					echo "Error: Unable to find specified instruction set."
					exit 0
				fi
			elif [[ ! -z "$(echo "$command" | grep "@REQUIRE_API")" ]]; then
				parse=($command)
				if [[ -f "$TDLIB/Services/LegacySupport/TDAPI/TDUserProgrammableAPI-v$command.tis" ]]; then
					source "$TDLIB/Services/LegacySupport/TDAPI/TDUserProgrammableAPI-v$command.tis"
				else
					echo "ERROR: API Version $command does not exist in LegacySupport."
					exit 0
				fi
			elif [[ ! -z $command ]]; then
				echo "@PROG_START_POINT" > "$CACHE/tdinterpreter/cmd"
				echo "$command" >> "$CACHE/tdinterpreter/cmd"
				chmod +x "$CACHE/tdinterpreter/cmd"
				"$SYSTEM/libexec/exec" "../../cache/tdinterpreter/cmd"
			fi
		done
	else
		echo "@PROG_START_POINT" > "$CACHE/tdinterpreter/cmd"
		echo "$1" >> "$CACHE/tdinterpreter/cmd"
		chmod +x "$CACHE/tdinterpreter/cmd"
		"$SYSTEM/libexec/exec" "../../cache/tdinterpreter/cmd"
	fi
else
	echo "Launching Interactive Interpreter Console failed."
	echo "Launch is not allowed."
	exit 0
fi