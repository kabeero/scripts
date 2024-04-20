#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
	curl -s "wttr.in/92618?format=j1" | jq -r '.current_condition[] | ("UV Index: " + .uvIndex)'
else
	curl -s "wttr.in/92618?format=j1" | jq -r '.current_condition[]'
fi
