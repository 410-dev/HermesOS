#!/bin/bash

if [[ "$HUID" -ne 0 ]]; then
    echo "${PERMISSION_DENIED}$HUID"
    exit 0
fi

# Reset NVRAM
if [[ "$1" == "reset" ]]; then
    echo -e "${RED}Are you sure you want to reset NVRAM?"
    echo "y/n"
    read yn
    if [[ "$yn" == "y" ]] || [[ "$yn" == "Y" ]]; then
        echo "Reseting NVRAM..."
        rm -rf "$NVRAM"
        mkdir -p "$NVRAM"
        echo "Done."
    else
        echo "Aborted."
    fi

# Set NVRAM variable
elif [[ "$1" == "set" ]]; then
    mkdir -p "$NVRAM"
	if [[ -z "$3" ]]; then	
		echo "${NOT_ENOUGH_ARGS}"
		exit 0
	fi
	if [[ ! -z "$(echo $2 | grep security/)" ]]; then
		echo "${OPERATION_NOT_PERMITTED}Editing security data in NVRAM is not permitted."
		exit 9
	else
        shift
        LOC="$NVRAM/$1"
        shift
		echo "$@" > "$LOC"
	fi

# Delete NVRAM variable
elif [[ "$1" == "delete" ]]; then
    mkdir -p "$NVRAM"
    if [[ -z "$2" ]]; then
        echo "${NOT_ENOUGH_ARGS}"
        exit 0
    fi
    if [[ ! -z "$(echo $2 | grep security/)" ]]; then
        echo "${OPERATION_NOT_PERMITTED}Editing security data in NVRAM is not permitted."
        exit 9
    else
        rm -rf "$NVRAM/$2"
    fi

# Get NVRAM variable
elif [[ "$1" == "get" ]]; then
    mkdir -p "$NVRAM"
    if [[ -z "$2" ]]; then
        ls -1 "$NVRAM" | while read conf
        do
            if [[ -f "$NVRAM/$conf" ]]; then
                echo "$conf        : $(cat "$NVRAM/$conf")"
            else
                echo "$conf - has multiple configurations"
            fi
        done
        exit 0
    fi
    if [[ -f "$NVRAM/$2" ]]; then
        cat "$NVRAM/$2"
    else
        echo "${NO_SUCH_FILE}$2"
        exit 9
    fi
else
    echo "Invalid parameter: $1"
    exit 9
fi
