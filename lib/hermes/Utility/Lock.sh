#!/bin/bash

if [[ "$1" == "TooManyLoginAttempt" ]]; then
	mplxw USER/SECURITY/LOGIN_ATTEMPT "64" >/dev/null
fi