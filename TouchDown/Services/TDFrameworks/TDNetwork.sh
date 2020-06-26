#!/bin/bash
curl -Ls "$1" -o "$2"
exit $?