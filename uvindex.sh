curl -s "wttr.in/?format=j1" | jq -r '.current_condition[] | ("UV Index: " + .uvIndex)'
