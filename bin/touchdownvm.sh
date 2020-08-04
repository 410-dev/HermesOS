#!/bin/bash
function @REQUIRE_API() {
	source "$LIBRARY/TouchDownVM/Interface.tis"
	source "$LIBRARY/TouchDownVM/Machine.tis"
	source "$LIBRARY/TouchDownVM/System.tis"
}

function @IMPORT() {
	if [[ -f "$LIBRARY/TouchDownVM/$1.tis" ]]; then
		source "$LIBRARY/TouchDownVM/$1.tis"
	else
		echo "Error: Unable to find specified instruction set."
		exit 0
	fi
}

function @PROG_START_POINT(){
	echo -n ""
	source "$SYSTEMSUPPORT/Library/Developer/FileIO.iskit"
}

if [[ ! -f "$LIBRARY/TouchDownVM/API/1.1.0.tis" ]]; then
	echo "Installing TouchDownVM..."
	mkdir -p "$LIBRARY/TouchDownVM"
	unzip -q "$SYSTEMSUPPORT/Services/LegacySupport/vmdat.zip" -d "$LIBRARY/TouchDownVM"
	rm -rf "$LIBRARY/TouchDownVM/__MACOSX"
fi

source "$LIBRARY/TouchDownVM/API/1.1.0.tis"
export -f @PROG_START_POINT
export -f @IMPORT
export -f @REQUIRE_API

if [[ -z "$1" ]]; then
	echo "Missing argument: Program path"
	exit 9
elif [[ ! -f "$USERDATA/$1" ]]; then
	echo "Unable to find such program."
	exit 9
elif [[ -z "$(cat "$USERDATA/$1" | grep "@PROG_START_POINT")" ]]; then
	echo "Unable to start program: Unable to find @PROG_START_POINT"
	exit 9
fi

cat "$USERDATA/$1" | while read fileLine
do
	echo "$QuarantineData" | while read disabledCommand
	do
		if [[ $(echo "$fileLine") ==  "$disabledCommand "* ]]; then
			echo "Execution disabled by sandbox."
			cd "$DATA"
			exit 9
		elif [[ $(echo "$fileLine") ==  "bin $disabledCommand "* ]]; then
			echo "[Warning] This application will access to bin."
			cd "$DATA"
			exit 9
		fi
		exitc=$?
		if [[ $exitc == 9 ]]; then
			exit 9
		fi
	done
	exitc=$?
	if [[ $exitc == 9 ]]; then
		exit 9
	fi
done
exitc=$?
if [[ $exitc == 0 ]]; then
	if [[ $(bootarg.contains "verbose") == 1 ]]; then
		echo "[*] Verification complete."
	fi
	cd "$USERDATA"
	"$USERDATA/$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
	exitcode=$?
	cd "$DATA"
	exit $exitcode
fi