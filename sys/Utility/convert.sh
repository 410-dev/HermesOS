#!/bin/bash
export PREV_MAJOR="$1"
export PREV_MINOR="$2"
export PREV_EDIT="$3"
verbose "[${GREEN}*${C_DEFAULT}] Updating multiplex data..."
cp -nr "$OSSERVICES/Default/multiplex/"* "$LIBRARY/config/" 2>/dev/null
