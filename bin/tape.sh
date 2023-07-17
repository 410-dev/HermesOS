#!/bin/bash
if [[ ! -d "$LIBRARY/tape" ]]; then
    cp -r "$OSSERVICES/Library/tape" "$LIBRARY/tape"
fi

if [[ ! -d "$LIBRARY/tape" ]]; then
    echo "Unable to prepare tape."
    exit 1
fi

# Check if action binary exists
ACTION="$1"
if [[ ! -f "$LIBRARY/tape/bin/tape-$ACTION" ]]; then
    echo "Action not found."
    exit 1
fi

# Check if --target= is in the arguments
if [[ "$*" == *"--target="* ]]; then
    echo "Error: Target setting is not allowed."
    exit 1
fi

shift
TAPEPACKAGER="$LIBRARY/tape" "$LIBRARY/tape/bin/tape-$ACTION" "$@"
echo ""
exit $?
