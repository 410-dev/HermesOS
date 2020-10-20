#!/bin/bash
export PREV_MAJOR="$1"
export PREV_MINOR="$2"
export PREV_EDIT="$3"
verbose "[*] Updating multiplex data..."
cp -nr "$OSSERVICES/Default/multiplex/"* "$LIBRARY/config/"
