#!/bin/bash
function loadDefinition() {
	if [[ -d "$CACHE/definitions" ]]; then
		cd "$CACHE/definitions"
		for file in *.hdp
		do
			source "$file"
		done
	fi
}

loadDefinition

if [[ -f "$CACHE/updated" ]] && [[ -f "$NVRAM/DontStartInterfaceAfterUpgrade" ]]; then
	rm "$CACHE/updated" "$NVRAM/DontStartInterfaceAfterUpgrade"
	exit 0
elif [[ "$(mplxr USER/SECURITY/LOGIN_ATTEMPT)" == "64" ]]; then
	echo "Error: Unable to start user interface"
	echo "Error code: 64"
	echo "You entered wrong password more than 5 times."
	exit 0
fi
"$OSSERVICES/Utility/preload"
if [[ "$(mplxr USER/SECURITY/LOGIN_ATTEMPT)" == "64" ]]; then
	echo "Error: Unable to start user interface"
	echo "Error code: 64"
	echo "You entered wrong password more than 5 times."
	exit 0
fi

export USERN=$(mplxr "USER/user_name")
export MACHN=$(mplxr "SYSTEM/machine_name")
if [[ -z "$USERN" ]]; then
	export USERN="root"
fi
if [[ -z "$MACHN" ]]; then
	export MACHN="apple_terminal"
fi
cd "$ROOTFS"


while [[ true ]]; do
	if [[ -f "$CACHE/alert" ]] ; then
		cat "$CACHE/alert"
		rm "$CACHE/alert"
	fi
	if [[ "$(mplxr USER/INTERFACE/ALERT_PRESENT)" == "1" ]] ; then
		mplxr "USER/INTERFACE/ALERT"
		mplxw "USER/INTERFACE/ALERT_PRESENT" "0"
		mplxw "USER/INTERFACE/ALERT" ""
	fi
	echo -n "$USERN@$MACHN ~ # "
	read command
	export args=($command)
	export USERLV="1"
	if [[ "${args[0]}" == "../"* ]]; then
		echo "Error: Escaping /System/bin is disallowed. Use exec command."
	elif [[ -f "$SYSTEM/bin/${args[0]}" ]]; then
		if [[ "${args[0]}" == "lec" ]]; then
			echo -n ""
		else
			export lastExecutedCommand="$command"
		fi
		"$SYSTEM/bin/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}"
	elif [[ -z "$command" ]]; then
		echo -n ""
	else
		echo "Command not found: ${args[0]}"
	fi
	export USERLV="1"
	if [[ -f "$CACHE/stdown" ]]; then
		verbose "[*] Flushing cache data..."
		rm -rf "$CACHE"
		exit 0
	elif [[ -f "$CACHE/rboot" ]]; then
		verbose "[*] Flushing cache data..."
		rm -rf "$CACHE"
		exit 100
	elif [[ -f "$CACHE/uirestart" ]]; then
		rm -f "$CACHE/uirestart"
		exit 101
	elif [[ -f "$CACHE/defreload" ]]; then
		loadDefinition
	fi
done