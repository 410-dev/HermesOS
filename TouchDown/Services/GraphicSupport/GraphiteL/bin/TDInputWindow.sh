#!/bin/bash
echo $("$(dirname "$0")/TDGraphicalUIRenderer" --stdout --inputbox "$1" 0 0)