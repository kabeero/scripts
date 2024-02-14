#!/usr/bin/env bash

# > dock 0
# [UNDOCKING] Enabling Sleep...
# > dock
# [UNDOCKED] Sleep Enabled
# > dock 1
# [DOCKING] Disabling Sleep...
# > dock
# [DOCKED] Sleep Disabled

if [[ $# -eq 1 ]]; then
	if [[ $1 -eq 0 ]]; then
		printf '[UNDOCKING] Enabling Sleep...\n'
		sudo pmset -c DisableSleep 0
	else
		printf '[DOCKING] Disabling Sleep...\n'
		sudo pmset -c DisableSleep 1
	fi;
else
	current_sleep=$(pmset -g | grep -i SleepDisabled | awk -F '\t' '{print $3}')
	if [[ $current_sleep -eq 0 ]]; then
		printf '[UNDOCKED] Sleep Enabled\n'
	elif [[ $current_sleep -eq 1 ]]; then
		printf '[DOCKED] Sleep Disabled\n'
	fi;
fi;
