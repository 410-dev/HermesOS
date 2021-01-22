#!/bin/bash
export PermissionData="$1"
export ExecutionType="$2"
export AccessLocation="$3"

export EntitlementLoc="$OSSERVICES/Library/Services/Fort/entitlements"

syslog "Fort Manager" "There is a request."
syslog "Fort Manager" "PermissionData = $1"
syslog "Fort Manager" "ExecutionType = $2"
syslog "Fort Manager" "AccessLocation = $3"

if [[ "$ExecutionType" == "fsys" ]]; then
	source "$EntitlementLoc/filesystems.entitlement"
	syslog "Fort Manager" "Data from entitlement file: $(cat "$EntitlementLoc/filesystems.entitlement")"
elif [[ "$ExecutionType" == "exec" ]]; then
	source "$EntitlementLoc/executables.entitlement"
	syslog "Fort Manager" "Data from entitlement file: $(cat "$EntitlementLoc/executables.entitlement")"
else
	syslog "Fort Manager - Error" "Execution type is incorrect."
	echo "-9"
	exit
fi

if [[ "$PermissionData" == "0" ]]; then
	echo "$lv0" | while read prohibited
	do
		syslog "Fort Manager" "Testing: $prohibited"
		syslog "Fort Manager" "Result: $(echo "$AccessLocation" | grep "$prohibited")"
		if [[ ! -z "$(echo "$AccessLocation" | grep "$prohibited")" ]] && [[ ! -z "$prohibited" ]]; then
			syslog "Fort Manager" "There was banned entitlement data!"
			syslog "Fort Manager" "Line from entitlement: $prohibited"
			syslog "Fort Manager" "Access Point: $AccessLocation"
			syslog "Fort Manager" "Access blocked."
			touch "$CACHE/auth"
			break
		fi
	done
elif [[ "$PermissionData" == "1" ]]; then
	echo "$lv1" | while read prohibited
	do
		syslog "Fort Manager" "Testing: $prohibited"
		syslog "Fort Manager" "Result: $(echo "$AccessLocation" | grep "$prohibited")"
		if [[ ! -z "$(echo "$AccessLocation" | grep "$prohibited")" ]] && [[ ! -z "$prohibited" ]]; then
			syslog "Fort Manager" "There was banned entitlement data!"
			syslog "Fort Manager" "Line from entitlement: $prohibited"
			syslog "Fort Manager" "Access Point: $AccessLocation"
			syslog "Fort Manager" "Access blocked."
			touch "$CACHE/auth"
			break
		fi
	done
elif [[ "$PermissionData" == "2" ]]; then
	echo "$lv2" | while read prohibited
	do
		syslog "Fort Manager" "Testing: $prohibited"
		syslog "Fort Manager" "Result: $(echo "$AccessLocation" | grep "$prohibited")"
		if [[ ! -z "$(echo "$AccessLocation" | grep "$prohibited")" ]] && [[ ! -z "$prohibited" ]]; then
			syslog "Fort Manager" "There was banned entitlement data!"
			syslog "Fort Manager" "Line from entitlement: $prohibited"
			syslog "Fort Manager" "Access Point: $AccessLocation"
			syslog "Fort Manager" "Access blocked."
			touch "$CACHE/auth"
			break
		fi
	done
else
	echo "-9"
	exit
fi

if [[ -f "$CACHE/auth" ]]; then 
	echo "-9"
	rm -rf "$CACHE/auth"
else
	syslog "Fort Manager" "Access authorized!"
	echo "0"
fi
