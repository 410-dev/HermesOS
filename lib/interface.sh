#!/bin/bash
if [[ -f "$CACHE/updated" ]] && [[ -f "$NVRAM/DontStartInterfaceAfterUpgrade" ]]; then
	rm "$CACHE/updated" "$NVRAM/DontStartInterfaceAfterUpgrade"
	exit 0
fi
"$SYSTEMSUPPORT/Utility/preload"
export USERN=$(mplxr "USER/user_name")
export MACHN=$(mplxr "SYSTEM/machine_name")
if [[ -z "$USERN" ]]; then
	export USERN="root"
fi
if [[ -z "$MACHN" ]]; then
	export MACHN="apple_terminal"
fi
cd "$CACHE/definitions"
for file in *.hdp
do
	source "$file"
done
cd "$ROOTFS"
export logSuffix="$(<"$CACHE/SESSION_NUM")"
while [[ true ]]; do
	"$SYSTEM/lib/interfacebulletin"
	cd "$ROOTFS"
	echo -n "$USERN@$MACHN ~ # "
	read command
	args=($command)
	if [[ "${args[0]}" == "../"* ]]; then
		echo "Error: Escaping /System/bin is disallowed. Use exec command."
	elif [[ -f "$SYSTEM/bin/${args[0]}" ]]; then
		echo "[IN] [$(date +"%Y-%m-%d %H:%M")] COMMAND ENTERED: $command" >> "$LIBRARY/Logs/INTERFACE_$logSuffix.tlog"
		echo "[OUT-START]" >> "$LIBRARY/Logs/INTERFACE_$logSuffix.tlog"
		if [[ "${args[0]}" == "lec" ]]; then
			echo -n ""
		else
			export lastExecutedCommand="$command"
		fi
		"$SYSTEM/bin/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}" | tee -a "$LIBRARY/Logs/INTERFACE_$logSuffix.tlog"
		echo "[OUT-END]" >> "$LIBRARY/Logs/INTERFACE_$logSuffix.tlog"
		echo "$lastExecutedCommand" >> "$LIBRARY/Logs/history"
	elif [[ -z "$command" ]]; then
		echo -n ""
	else
		echo "Command not found: ${args[0]}"
		echo "$lastExecutedCommand" >> "$LIBRARY/Logs/history"
	fi
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
	fi
done