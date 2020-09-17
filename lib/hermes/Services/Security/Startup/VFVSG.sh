#!/bin/bash
if [[ "$VFVSG" == 0 ]]; then
	export endCode=0
	exit 0
fi
if [[ ! -f "$NVRAM/VFVSG/systemroot.hcx" ]]; then
	if [[ ! -f "$MULTIPLEX/USER/INTERFACE/START_MODE" ]] || [[ "$(<"$MULTIPLEX/USER/INTERFACE/START_MODE")" == "Setup" ]]; then
		export endCode=0
		exit 0
	fi
	export CXS_SIGNSEED="$(md5 -qs "OS=Hermes;MAJOR=10;MANUFACTURE=410")"
	export CXS_CODESIGN="$(echo "entitlement=$CXS_ENTITLEMENT;signseed=$CXS_SIGNSEED" | shasum -a 512)"
	if [[ ! -z "$(cat "$NVRAM/VFVSG/systemroot.hcx" | grep "CXS_CODESIGN")" ]]; then
		export endCode=0
		exit 0
	else
		export endCode=1
		exit 1
	fi
else
	export endCode=1
	exit 1
fi