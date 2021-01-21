#!/bin/bash
export PermissionData="$1"
export ExecutionType="$2"
export AccessLocation="$3"

export EntitlementLoc="$OSSERVICES/Library/Services/Fort/entitlements"

Log "Fort Manager" "There is a request."
Log "Fort Manager" "PermissionData = $1"
Log "Fort Manager" "ExecutionType = $2"
Log "Fort Manager" "AccessLocation = $3"

if [[ "$ExecutionType" == "fsys" ]]; then
	source "$EntitlementLoc/filesystems.entitlement"
	Log "Fort Manager" "Data from entitlement file: $(cat "$EntitlementLoc/filesystems.entitlement")"
elif [[ "$ExecutionType" == "exec" ]]; then
	source "$EntitlementLoc/executables.entitlement"
	Log "Fort Manager" "Data from entitlement file: $(cat "$EntitlementLoc/executables.entitlement")"
else
	Log "Fort Manager - Error" "Execution type is incorrect."
	echo "-9"
	exit
fi

if [[ "$PermissionData" == "0" ]]; then
	echo "$lv0" | while read prohibited
	do
		Log "Fort Manager" "Testing: $prohibited"
		Log "Fort Manager" "Result: $(echo "$AccessLocation" | grep "$prohibited")"
		if [[ ! -z "$(echo "$AccessLocation" | grep "$prohibited")" ]] && [[ ! -z "$prohibited" ]]; then
			Log "Fort Manager" "There was banned entitlement data!"
			Log "Fort Manager" "Line from entitlement: $prohibited"
			Log "Fort Manager" "Access Point: $AccessLocation"
			Log "Fort Manager" "Access blocked."
			touch "$CACHE/auth"
			break
		fi
	done
elif [[ "$PermissionData" == "1" ]]; then
	echo "$lv1" | while read prohibited
	do
		Log "Fort Manager" "Testing: $prohibited"
		Log "Fort Manager" "Result: $(echo "$AccessLocation" | grep "$prohibited")"
		if [[ ! -z "$(echo "$AccessLocation" | grep "$prohibited")" ]] && [[ ! -z "$prohibited" ]]; then
			Log "Fort Manager" "There was banned entitlement data!"
			Log "Fort Manager" "Line from entitlement: $prohibited"
			Log "Fort Manager" "Access Point: $AccessLocation"
			Log "Fort Manager" "Access blocked."
			touch "$CACHE/auth"
			break
		fi
	done
elif [[ "$PermissionData" == "2" ]]; then
	echo "$lv2" | while read prohibited
	do
		Log "Fort Manager" "Testing: $prohibited"
		Log "Fort Manager" "Result: $(echo "$AccessLocation" | grep "$prohibited")"
		if [[ ! -z "$(echo "$AccessLocation" | grep "$prohibited")" ]] && [[ ! -z "$prohibited" ]]; then
			Log "Fort Manager" "There was banned entitlement data!"
			Log "Fort Manager" "Line from entitlement: $prohibited"
			Log "Fort Manager" "Access Point: $AccessLocation"
			Log "Fort Manager" "Access blocked."
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
	Log "Fort Manager" "Access authorized!"
	echo "0"
fi
