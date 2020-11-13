#!/bin/bash

function copyFiles() {

}

function beginOSInstallation() {

}

function finalizeInstallation() {

}


if [[ "$1" == "cp" ]]; then
	copyFiles
elif [[ "$1" == "inst" ]]; then
	beginOSInstallation
elif [[ "$1" == "fin" ]]; then
	finalizeInstallation
fi