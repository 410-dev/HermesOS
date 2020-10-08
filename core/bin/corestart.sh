#!/bin/bash
export ERROR="$CORE/bin/error"
mkdir -p "$CACHE/definitions"
verbose "[*] Hello from CoreStart."
if [[ -f "$CORE/resources/coreversion" ]]; then
	verbose "[*] Core version: $(<"$CORE/resources/coreversion")"
else
	verbose "[!] Warning: Core version data not found."
fi
verbose "[*] Running preload definitions..."
export ppwd="$PWD"
if [[ ! -z "$(ls "$CORE/extensions/"*.hcdef 2>/dev/null)" ]]; then
	cd "$CORE/extensions/"
	verbose "[*] Loading preload definitions: Core"
	for file in *.hcdef
	do
		verbose "[*] Loading: $file"
		source "$file"
		cp "$file" "$CACHE/definitions/"
	done
else
	verbose "[!] No preload definitions exist for core."
fi
export list=""
if [[ ! -z "$(ls "$OSSERVICES/predefinitions/"*.hdp 2>/dev/null)" ]]; then
	cd "$OSSERVICES/predefinitions/"
	verbose "[*] Loading preload definitions: System"
	for file in *.hdp
	do
		verbose "[*] Loading: $file"
		source "$file"
	done
else
	verbose "[!] No preload definitions exist for system."
fi
cd "$ppwd"
export ppwd=""
verbose "[*] Loading cstartup agents..."
"$CORE/bin/extensionloader"
export returned=$?
if [[ -f "$BOOTREFUSE" ]]; then
	exit 1
elif [[ "$returned" == 0 ]]; then
	verbose "[*] Core startup agents loaded successfully."
else
	"$ERROR" "[-] Failed loading core startup agents."
	exit 1
fi
verbose "[*] Process complete."
if [[ -f "$OSSERVICES/startupagents/agentlist" ]]; then
	verbose "[*] Loading startupagents..."
	"$CORE/bin/startupagent"
	export returned=$?
	if [[ "$returned" == 0 ]]; then
		verbose "[*] Startup agents loaded successfully."
	else
		"$ERROR" "[-] Failed loading startup agents."
		exit 1
	fi
else
	verbose "[*] No startup agent installed."
fi
if [[ -f "$OSSERVICES/backgroundworkers/workerslist" ]]; then
	verbose "[*] Loading background workers..."
	"$CORE/bin/backgroundworker"
	export returned=$?
	if [[ "$returned" == 0 ]]; then
		verbose "[*] Workers loaded successfully."
	else
		"$ERROR" "[-] Failed loading startup agents."
		exit 1
	fi
else
	verbose "[*] No background worker installed."
fi
if [[ ! -z "$(ls "$CACHE/definitions" | grep ".hcdef")" ]]; then
	verbose "[*] Trying to transcode hcdef to hdp..."
	cd "$CACHE/definitions"
	for file in *.hcdef
	do
		verbose "[*] Transcoding: $file"
		mv "$file" "$file.hdp"
	done
fi
exit 0