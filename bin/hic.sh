#!/bin/bash
if [[ ! -z $(bootarg.contains "iamdeveloper") == 1 ]] && [[ -f "$NVRAM/enable_dev_option" ]]; then
	mkdir -p "$CACHE/tdinterpreter"
	if [[ -z "$1" ]]; then
		println "Hermes Interpreter Interactive Console"
		println "Type ISA.manual to see available commands. To stop, type exit."
		while [[ true ]]; do
			echo -n "\$ "
			read command
			if [[ $command == "exit" ]]; then
				break
			elif [[ ! -z "$(echo "$command" | grep "@IMPORT")" ]]; then
				parse=($command)
				if [[ -f "$TDLIB/Library/Developer/${parse[1]}.iskit" ]]; then
					source "$TDLIB/Library/Developer/${parse[1]}.iskit"
				elif [[ -f "$DATA/Library/Developer/${parse[1]}.iskit" ]]; then
					source "$DATA/Library/Developer/${parse[1]}.iskit"
				else
					echo "Error: Unable to find specified instruction set."
					exit 0
				fi
			elif [[ ! -z "$(echo "$command" | grep "@TDIMPORT")" ]]; then
				if [[ -f "$NVRAM/enable_tdapi" ]]; then
					parse=($command)
					if [[ -f "$TDLIB/Library/Developer/${parse[1]}.iskit" ]]; then
						source "$TDLIB/Library/Developer/${parse[1]}.iskit"
					elif [[ -f "$DATA/Library/Developer/${parse[1]}.iskit" ]]; then
						source "$DATA/Library/Developer/${parse[1]}.iskit"
					else
						echo "Error: Unable to find specified instruction set."
						exit 0
					fi
				else
					echo "Error: TouchDown instruction sets are disabled."
				fi
			elif [[ ! -z "$(echo "$command" | grep "@REQUIRE_TDAPI")" ]]; then
				parse=($command)
				if [[ -f "$TDLIB/Services/LegacySupport/TDAPI/TDUserProgrammableAPI-v${command[1]}.tis" ]]; then
					source "$TDLIB/Services/LegacySupport/TDAPI/TDUserProgrammableAPI-v${command[1]}.tis"
				else
					echo "ERROR: API Version $command does not exist in LegacySupport."
					exit 0
				fi
			elif [[ ! -z "$(echo "$command" | grep "@REQUIRE")" ]]; then
				parse=($command)
				if [[ -f "$TDLIB/Services/LegacySupport/TDAPI/VirtualISAKit-v${command[1]}.iskit" ]]; then
					source "$TDLIB/Services/LegacySupport/TDAPI/VirtualISAKit-v${command[1]}.iskit"
				else
					echo "ERROR: Instruction Kit $command does not exist in LegacySupport."
					exit 0
				fi
			elif [[ ! -z $command ]]; then
				echo "@PROG_START_POINT" > "$CACHE/tdinterpreter/cmd"
				echo "$command" >> "$CACHE/tdinterpreter/cmd"
				chmod +x "$CACHE/tdinterpreter/cmd"
				"$SYSTEM/bin/exec" "../../cache/tdinterpreter/cmd"
			fi
		done
	else
		echo "@PROG_START_POINT" > "$CACHE/tdinterpreter/cmd"
		echo "$1" >> "$CACHE/tdinterpreter/cmd"
		chmod +x "$CACHE/tdinterpreter/cmd"
		"$SYSTEM/bin/exec" "../../cache/tdinterpreter/cmd"
	fi
else
	echo "Launching Interactive Interpreter Console failed."
	exit 0
fi