#!/bin/bash
verbose "[*] Hello from CoreStart."
if [[ -f "$CORE/resources/coreversion" ]]; then
	verbose "[*] Core version: $(<"$CORE/resources/coreversion")"
else
	verbose "[-] Warning: Core version data not found."
fi
verbose "[*] Loading cstartup agents..."
"$CORE/bin/cstartupagent"
if [[ "$?" == 0 ]]; then
	verbose "[*] Core startup agents loaded successfully."
else
	echo "[-] Failed loading core startup agents."
	exit 1
fi
if [[ -f "$SYSTEM/lib/startupagents/agentlist" ]]; then
	verbose "[*] Loading startupagents..."
	"$CORE/bin/startupagent"
	if [[ "$?" == 0 ]]; then
		verbose "[*] Startup agents loaded successfully."
	else
		echo "[-] Failed loading startup agents."
		exit 1
	fi
fi
