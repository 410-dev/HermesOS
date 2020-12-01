#!/bin/bash
if [[ "$HUID" -ne 0 ]]; then
	echo "Permission denied: $HUID"
	exit 0
fi

export programversion="1.1"

echo "FRESTRICTOR - Let your files in your hand"
echo "========================================="

if [[ ! -d "$NVRAM/security/frestrictor_trustedagents" ]]; then
	mkdir -p "$NVRAM/security/frestrictor_trustedagents"
	touch "$NVRAM/security/frestrictor_trustedagents/ls"
	touch "$NVRAM/security/frestrictor_trustedagents/copy"
	touch "$NVRAM/security/frestrictor_trustedagents/mkdir"
	touch "$NVRAM/security/frestrictor_trustedagents/mv"
	touch "$NVRAM/security/frestrictor_trustedagents/nano"
	touch "$NVRAM/security/frestrictor_trustedagents/open"
	touch "$NVRAM/security/frestrictor_trustedagents/read"
	touch "$NVRAM/security/frestrictor_trustedagents/rm"
	touch "$NVRAM/security/frestrictor_trustedagents/setrunnable"
	touch "$NVRAM/security/frestrictor_trustedagents/super"
	touch "$NVRAM/security/frestrictor_trustedagents/tpaste"
	touch "$NVRAM/security/frestrictor_trustedagents/installdriver"
fi

echo "Frestrictor $programversion - Management Panel"

if [[ -f "$NVRAM/frestrictor_config" ]]; then
	if [[ ! -z "$(echo "$NVRAM/frestrictor_config" | grep "full-disable")" ]]; then
		echo "[DISABLED]"
	fi
fi


while [[ true ]]; do
	echo ""
	echo "1. See trusted processes"
	echo "2. Add trusted process"
	echo "3. Remove trusted process"
	echo "4. Exit"
	echo ""
	echo -n "Enter number > "
	read number

	if [[ "$number" == "1" ]]; then
		echo "Start------------"
		ls -1 "$NVRAM/security/frestrictor_trustedagents"
		echo "End--------------"
	elif [[ "$number" == "2" ]]; then
		echo -n "Process name you want to add: "
		read proc_name
		if [[ ! -z "$proc_name" ]]; then
			touch "$NVRAM/security/frestrictor_trustedagents/$proc_name"
		else
			echo "Error: Process name cannot be empty."
		fi
	elif [[ "$number" == "3" ]]; then
		echo -n "Process name you want to remove: "
		read proc_name
		if [[ -f "$NVRAM/security/frestrictor_trustedagents/$proc_name" ]] && [[ ! -z "$proc_name" ]] ; then
			rm -rf "$NVRAM/security/frestrictor_trustedagents/$proc_name"
		else
			echo "Error: Not found."
		fi
	else
		exit 0
	fi
done