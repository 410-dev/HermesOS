#!/bin/bash
verbose "[*] Hello from CoreStart."
if [[ -f "$CORE/resources/coreversion" ]]; then
	verbose "[*] Core version: $(<"$CORE/resources/coreversion")"
else
	verbose "[-] Warning: Core version data not found."
fi
verbose "[*] Running preload definitions..."
export ppwd="$PWD"
if [[ ! -z "$(ls "$CORE/predefinitions/"*.hdp 2>/dev/null)" ]]; then
	cd "$CORE/predefinitions/"
	verbose "[*] Loading preload definitions: Core"
	for file in *.hdp
	do
		source "$file"
	done
else
	verbose "[-] No preload definitions exist for core."
fi
export list=""
if [[ ! -z "$(ls "$SYSTEM/lib/predefinitions/"*.hdp 2>/dev/null)" ]]; then
	cd "$SYSTEM/lib/predefinitions/"
	verbose "[*] Loading preload definitions: System"
	for file in *.hdp
	do
		source "$file"
	done
else
	verbose "[-] No preload definitions exist for system."
fi
cd "$ppwd"
export ppwd=""
verbose "[*] Loading cstartup agents..."
"$CORE/bin/cstartupagent"
export returned=$?
if [[ "$returned" == 0 ]]; then
	verbose "[*] Core startup agents loaded successfully."
else
	echo "[-] Failed loading core startup agents."
	exit 1
fi
if [[ -f "$SYSTEM/lib/startupagents/agentlist" ]]; then
	verbose "[*] Loading startupagents..."
	"$CORE/bin/startupagent"
	export returned=$?
	if [[ "$returned" == 0 ]]; then
		verbose "[*] Startup agents loaded successfully."
	else
		echo "[-] Failed loading startup agents."
		exit 1
	fi
fi
