#!/bin/bash

"$OSSERVICES/Utility/Authenticator" --authenticate "Authentication"
if [[ "$?" == 0 ]]; then
	declare -i HUID
	export HUID="0"
	"$SYSTEM/bin/$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
fi
export HUID="1"