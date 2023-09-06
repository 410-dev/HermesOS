#!/bin/bash
echo "Hermes RecoveryOS"
echo "Type help to see available commands."
echo "Selecting disk..."
while [[ true ]]; do
	echo -n "RECOVERY > "
	read commands
	if 
	[[ "$commands" == "cleardisk" ]] || 
	[[ "$commands" == "help" ]] || 
	[[ "$commands" == "install" ]] || 
	[[ "$commands" == "updatept" ]] ||
	[[ "$commands" == "nvreset_force" ]] ||
	[[ "$commands" == "nvreset" ]]; then
		"$commands" "rec_mode_set_unlocked_installer"
	elif [[ "$commands" == "shutdown" ]]; then
		rm -rf "$SYSCAC"
		break
		unset cleardisk
		unset help
		unset install
		unset updatept
		unset nvreset
	elif [[ ! -z "$(echo "$commands" | grep ".DATA")" ]]; then
		echo "DRIVER DATA: "
		cat "$SYSLOC/$commands"
	elif [[ "$commands" == "BOOT" ]] || [[ "$commands" == "SYSTEM" ]]; then
		echo "May not execute system component."
	else
		echo "Command not found."
	fi
done
