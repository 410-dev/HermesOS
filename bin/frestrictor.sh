#!/bin/bash
if [[ "$HUID" -ne 0 ]]; then
	echo "Permission denied: $HUID"
	exit 0
fi

export compatibleKernel="3.0.1"
export compatibleSystem="10.0.0"
export programversion="1.0"

echo "FRESTRICTOR - Let your files in your hand"
echo "========================================="
if [[ "$OS_Version" == "$compatibleSystem" ]]; then
	echo -n ""
else
	echo "OS Version is incompatible!"
	echo "Required: $compatibleSystem"
	echo "Actual: $OS_Version"
	exit 0
fi

if [[ "$CoreVersion" == "$compatibleKernel" ]]; then
	echo -n ""
else
	echo "OS Version is incompatible!"
	echo "Required: $compatibleKernel"
	echo "Actual: $CoreVersion"
	exit 0
fi

if [[ ! -d "$NVRAM/security/frestrictor_trustedagents" ]]; then
	mkdir -p "$NVRAM/security/frestrictor_trustedagents"
fi

echo "Frestrictor $programversion - Management Panel"


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