#!/bin/bash
if [[ ! -z "$1" ]]; then
	"$MEM_CTL" define data tempcopy "$1"
fi
