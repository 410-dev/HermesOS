#!/bin/bash
if [[ -z "$(echo $b_arg | grep enforce_cli)" ]]; then
	while [[ true ]]; do
		if [[ ! -z "$(ls $CACHE/tmp/$SWAP_LOC | grep F0x)" ]]; then
			cd "$CACHE/tmp/$SWAP_LOC"
			echo "" > "table"
			for f in *x* ; do
				export "$f"="$(<$f)"
				echo "$f=$(<$f)" >> "table"
			done
		fi
		cd "$CACHE/def"
		for file in *.def
		do
			source "$file"
		done
		export command="$(graphite_input "Command: ")"
		args=($command)
		if [[ "$command" == "gui-stop" ]]; then
			exit
		elif [[ -f "$SYSTEM/libexec/${args[0]}" ]]; then
			export OUTPUT=$("$SYSTEM/libexec/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}")
			$graphitelib/TDGraphicalUIRenderer --title "Output from Command" --msgbox "$OUTPUT" 20 60
			export lastExecutedCommand="$command"
			echo "$lastExecutedCommand" >> "$DATA/logs/history"
		elif [[ -z "$command" ]]; then
			echo -n ""
		else
			echo "Command not found: ${args[0]}"
			echo "$lastExecutedCommand" >> "$DATA/logs/history"
		fi
		if [[ -f "$CACHE/SIG/shell_close" ]]; then
			echo "[*] Exiting..."
			exit 0
		elif [[ -f "$CACHE/SIG/shell_reload" ]]; then
			echo "[*] Reloading shell..."
			rm -f "$CACHE/SIG/shell_reload"
			exit 0
		fi
	done
else
	echo "[-] CLI enforced. Unable to start GUI engine."
fi