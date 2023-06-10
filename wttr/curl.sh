#!/usr/bin/env sh
index=$( \
    curl -s "wttr.in/91106?format=j1" | \
        jq -r '.current_condition[] | ("UV Index: " + .uvIndex)'
)
echo
echo "🌞 $index"
