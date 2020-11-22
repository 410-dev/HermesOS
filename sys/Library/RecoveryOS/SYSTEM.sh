#!/bin/bash
echo "Hermes RecoveryOS"
echo "Type help to see available commands."
export selectedDisk=""
while [[ true ]]; do
	echo -n "RECOVERY > "
	read commands
	if 
	[[ "$commands" == "cleardisk" ]] || 
	[[ "$commands" == "help" ]] || 
	[[ "$commands" == "install" ]] || 
	[[ "$commands" == "selectdisk" ]] || 
	[[ "$commands" == "updatept" ]]; then
		"$commands"
	elif [[ "$commands" == "shutdown" ]]; then
		rm -rf "$SYSCAC"
		break
	elif [[ ! -z "$(echo "$commands" | grep ".DATA")" ]]; then
		echo "DRIVER DATA: "
		cat "$SYSLOC/$commands"
	elif [[ "$commands" == "BOOT" ]] || [[ "$commands" == "SYSTEM" ]]; then
		echo "May not execute system component."
	else
		echo "Command not found."
	fi
done
