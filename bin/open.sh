#!/bin/bash
if [[ -z "$1" ]]; then
	sys_log "open" "Application name is missing."
	echo "${MISSING_PARAM}app name"
	exit
fi

if [[ -f "$USERDATA/$1" ]]; then
	sys_log "open" "User tried to install an application."
	sys_log "open" "Warning: Installation via open command will be unsupported soon."
	echo "Warning: Installation via open command will be unsupported soon."
	"$SYSTEM/bin/packager" --install "$1"
elif [[ -d "$DATA/Applications/$1" ]]; then
	if [[ -f "$DATA/Applications/$1/runner" ]]; then
		if [[ ! -f "$DATA/Applications/$1/INFO" ]]; then
			echo "Unable to execute application: INFO is missing."
			exit
		fi
		source "$DATA/Applications/$1/INFO"
		if [[ "$BUILTFOR" == "$SDK_COMPATIBILITY" ]] || [[ $(bootArgumentHas "ignore_sdk_compatibility") == 1 ]] || [[ "$BUILTFOR" == "all" ]]; then
			chmod +x "$DATA/Applications/$1/runner"
			export BundlePath="$DATA/Applications/$1"
			if [[ "$ALLOCTHREAD" == "backgroundservice" ]]; then
				"$DATA/Applications/$1/runner" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" &
				echo "Background Service launched."
			else
				"$DATA/Applications/$1/runner" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
				exit $?
			fi
		else
			echo "Application is incompatible."
		fi
	else
		echo "Unable to execute application: Runner is missing."
		exit
	fi
else
	echo "Application not found."
fi