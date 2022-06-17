curl -s "wttr.in/?format=j1" | jq '.current_condition[] | {uvIndex} | join(" ")' | tr -d '"'
