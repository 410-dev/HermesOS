#!/bin/bash

# EDIT THE VALUES HERE
export SYSNAME="Hermes Recovery"
export SYSVERS="20.0"
export SYSEXEC="SYSTEM"

# DO NOT EDIT FROM HERE
export SYSLOC="$RECOVERY"
export SYSCAC="$CACHE"
echo "Loading: $SYSNAME $SYSVERS"
echo "Selecting disk..."
export selectedDisk="$DISK_LOC"
cd "$SYSLOC"
while read DATAFILE
do
	source "$SYSLOC/$DATAFILE"
done <<< "$(ls -p | grep -v / | grep ".DATA")"

"$(dirname "$0")/$SYSEXEC"