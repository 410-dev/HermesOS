#!/bin/bash

# MINISYSTEM is a small, lightweighted system
# that is designed for specific purpose.

# EDIT THE VALUES HERE
export SYSNAME="Hermes Recovery"
export SYSVERS="16.0"
export SYSEXEC="SYSTEM"

# DO NOT EDIT FROM HERE
export SYSLOC="$RECOVERY"
export SYSCAC="$CACHE"
echo "Loading: $SYSNAME $SYSVERS"
cd "$SYSLOC"
while read DATAFILE
do
	source "$SYSLOC/$DATAFILE"
done <<< "$(ls -p | grep -v / | grep ".DATA")"

"$(dirname "$0")/$SYSEXEC"