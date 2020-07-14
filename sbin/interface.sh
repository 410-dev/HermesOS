#!/bin/bash
"$TDLIB/Utility/preload"
clear
if [[ "$(mplxr BOOT/PROTOCOL/EnterSafeMode)" == "0" ]]; then
	if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
		"$TDLIB/Services/TDFrameworks/TDUserLoginInit"
	else
		"$TDLIB/Services/TDFrameworks/TDUserLoginInit" >/dev/null
	fi
else
	echo "[!] System started with safe mode."
fi
SWAP_LOC="$(<$CACHE/SIG/swap_address)"
export lastExecutedCommand=""
export USERN=$(mplxr "USER/user_name")
export MACHN=$(mplxr "SYSTEM/machine_name")
cd "$CACHE/def"
for file in *.def
do
	source "$file"
done
cd "$ROOTFS"
export logSuffix="$(<"$CACHE/SESSION_NUM")"
while [[ true ]]; do
	"$SYSTEM/sbin/interfacebulletin"
	if [[ ! -z "$(ls $CACHE/tmp/$SWAP_LOC | grep F0x)" ]]; then
		cd "$CACHE/tmp/$SWAP_LOC"
		echo "" > "table"
		for f in *x* ; do
			export "$f"="$(<$f)"
			echo "$f=$(<$f)" >> "table"
		done
	fi
	if [[ -f "$CACHE/SIG/defreload" ]]; then
		cd "$CACHE/def"
		for file in *.def
		do
			source "$file"
		done
		rm "$CACHE/SIG/defreload"
	fi
	cd "$ROOTFS"
	echo -n "$USERN@$MACHN ~ # "
	read command
	args=($command)
	if [[ -f "$SYSTEM/libexec/${args[0]}" ]]; then
		echo "[IN] [$(date +"%Y-%m-%d %H:%M")] COMMAND ENTERED: $command"
		echo "[OUT-START]"
		"$SYSTEM/libexec/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}" | tee -a "$LIB/Logs/INTERFACE_$logSuffix.tlog"
		export lastExecutedCommand="$command"
		echo "[OUT-END]"
		echo "$lastExecutedCommand" >> "$LIB/Logs/history"
		echo "[OUT-END]"
	elif [[ -z "$command" ]]; then
		echo -n ""
	else
		echo "Command not found: ${args[0]}"
		echo "$lastExecutedCommand" >> "$LIB/Logs/history"
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