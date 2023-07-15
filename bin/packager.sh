#!/bin/bash

if [[ -z "$1" ]]; then
	sys_log "packager" "Action not defined."
	echo "${MISSING_PARAM}action"
elif [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
	if [[ -z "$2" ]]; then
		sys_log "installapp" "Package name is missing."
		echo "${MISSING_PARAM}app name"
		exit
	fi

	if [[ "$(access_fs "$PWD/$2")" -ne 0 ]]; then
        echo "${OPERATION_NOT_PERMITTED}Read File"
        exit 99
    fi

	if [[ -d "$CACHE/pkgunpack" ]] || [[ -d "$DATA/Applications/pkgunpack" ]]; then
		sys_log "installapp" "Error: Package installation process is already running."
		echo "Error: Package installation process is already running."
		exit
	fi

	if [[ -f "$PWD/$2" ]]; then
		echo "Unpacking..."
		sys_log "installapp" "Creating temporary directory..."
		mkdir -p "$CACHE/pkgunpack"
		sys_log "installapp" "Copying package..."
		mv "$PWD/$2" "$CACHE/package.tar.gz"
		sys_log "installapp" "Unpacking using tar..."
		tar -xf "$CACHE/package.tar.gz" -C "$CACHE/pkgunpack"
		sys_log "installapp" "Reading application info..."
		source "$CACHE/pkgunpack/INFO"
		sys_log "installapp" "Copying application content..."
		cp -r "$CACHE/pkgunpack" "$DATA/Applications/"
		sys_log "installapp" "Renaming package bundle..."
		mv "$DATA/Applications/pkgunpack" "$DATA/Applications/$APPNAME"
		sys_log "installapp" "Removing temporary contents..."
		rm -f "$CACHE/package.tar.gz"
		rm -rf "$CACHE/pkgunpack" "$DATA/Applications/pkgunpack"
		sys_log "installapp" "Installation complete."
		echo "Installation successful."
	else
		sys_log "installapp" "Package $2 not found."
		echo "Package not found."
	fi
elif [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
	if [[ -z "$2" ]]; then
		sys_log "removeapp" "Application name is missing."
		echo "${MISSING_PARAM}app name"
		exit
	fi

	if [[ -d "$DATA/Applications/$2" ]]; then
		echo "Removing application..."
		sys_log "removeapp" "Removing application..."
		rm -rf "$DATA/Applications/$2"
		sys_log "removeapp" "Installation complete."
		echo "Removing successful."
	else
		sys_log "removeapp" "Application $2 not found."
		echo "Application not found."
	fi
elif [[ "$1" == "--install-driver" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		sys_log "installdriver" "Permission denied: $HUID"
	    echo "${PERMISSION_DENIED}$HUID"
	    exit 0
	fi

	if [[ -f "$PWD/$2" ]]; then
	    if [[ "$(access_fs "$PWD/$2")" -ne 0 ]]; then
	    	sys_log "installdriver" "Access denied: $PWD/$2"
	        echo "${OPERATION_NOT_PERMITTED}Read File"
	        exit 99
	    fi
	    sys_log "installdriver" "Installing package..."
	    echo "Installing package..."
	    sys_log "installdriver" "Unpacking package..."
	    unzip -o -q "$PWD/$2" -d "$LIBRARY/HardwareExtensions"
	    sys_log "installdriver" "Removing remnent..."
	    rm -rf "$LIBRARY/HardwareExtensions/__MACOSX"
	    sys_log "installdriver" "Done."
	    echo "${DONE}"
	else
		sys_log "installdriver" "Specified file does not exist."
	    echo "${NO_SUCH_FILE}$2"
	fi
elif [[ "$1" == "--remove-driver" ]]; then
	if [[ "$HUID" -ne 0 ]]; then
		sys_log "removedriver" "Permission denied: $HUID"
	    echo "${PERMISSION_DENIED}$HUID"
	    exit 0
	fi

	if [[ ! -z "$2" ]] && [[ -f "$LIBRARY/HardwareExtensions/$2".* ]]; then
		sys_log "removedriver" "Removing driver: $2"
		rm -rf "$LIBRARY/HardwareExtensions/$2".*
		sys_log "removedriver" "Driver removed."
	else
		sys_log "removedriver" "Driver not found."
		echo "Driver not found."
	fi
else
	sys_log "packager" "Unknown action."
	echo "Unknown action."
fi