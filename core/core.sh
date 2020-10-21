#!/bin/bash

function error() {
	echo "😵"
	verbose "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
	exit 120
}

function extensionLoader() {
	cd "$CORE/extensions"
	export agentlist="$(ls -p | grep -v / | grep ".hxe")" 2>/dev/null
	export exitStatus="0"
	echo "$agentlist" | while read agentname
	do
		if [[ ! -z "$agentname" ]]; then
			verbose "[*] Loading: $agentname"
			"./$agentname"
			export returned=$?
			if [[ "$returned" == 0 ]]; then
				verbose "[*] Load complete."
			elif [[ -f "$BOOTREFUSE" ]]; then
				echo "❌"
				verbose "Boot refused: $(cat "$BOOTREFUSE")"
				exit 2
			else
				verbose "[!] $agentname returned exit code $returned."
				error "Agent $agentname returned exit code $returned."
			fi
		fi
	done
	export agentlist=""
}

function osstart() {
	cd "$CORE/extensions"
	while read defname
	do
		verbose "[*] Reading memory allocation data: $defname"
		source "$CORE/extensions/$defname"
	done <<< "$(ls -p | grep -v / | grep ".hmref")"
	extensionLoader
}

function osstop() {
	verbose "[*] Loading lists of backgroundworkers..."
	ALIVE=$(ps -ax | grep "$CORE/extensions[/]")
	verbose "[*] Killing syncronously..."
	verbose "$ALIVE" | while read proc
	do
		if [[ ! -z "$proc" ]]; then
			frpid=($proc)
			kill -9 ${frpid[0]}
			verbose "[*] Killed PID: ${frpid[0]}"
		fi
	done
	verbose "[*] Background workers are closed."
}

function uistart() {
	if [[ -f "$OSSERVICES/interface" ]]; then
		export exitcode=1
		while [[ $exitcode -ne 0 ]] && [[ $exitcode -ne 100 ]]; do
			"$OSSERVICES/interface"
			exitcode="$?"
		done
		osstop
		exit "$exitcode"
	else
		echo "[-] OS Interface not found."
		echo "[-] Stopping core."
		osstop
		exit 0
	fi
}

if [[ "$1" == "osstart" ]]; then
	osstart
elif [[ "$1" == "uistart" ]]; then
	uistart
	exit $?
elif [[ "$1" == "osstop" ]]; then
	osstop
elif [[ "$1" == "error" ]]; then
	error "$2" "$3" "$4"
fi
