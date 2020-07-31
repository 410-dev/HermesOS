#!/bin/bash
echo $("$(dirname "$0")/engine" --stdout --inputbox "$1" 0 0)