#!/usr/bin/env bash

set -uo pipefail

if [ ! command -v gum &> /dev/null ]; then
    echo
    echo "❗ Please install gum"
    echo
    exit 1
fi

echo

line=$(xinput list | gum filter --header "Choose a device")
id=$(echo $line | grep -Eo "id=[0-9]+" | sed -e 's/id=//')
[[ -z $id ]] && exit 1

prop_line=$(xinput list-props $id | gum filter --header "Choose a property" --value natural)
[[ -z $prop_line ]] && exit 1
prop_ids=($(echo $prop_line | grep -Eo "[0-9]+"))
prop_label=$(echo $prop_line | sed -e "s/.*libinput \(.*\) (.*/\1/")
[[ -z $prop_ids ]] && exit 1

case $(gum choose "Enabled" "Disabled" --header "Set $prop_label to") in
    "Enabled")
        xinput set-prop $id ${prop_ids[0]} 1
        echo
        echo "🟢 Enabled $prop_label"
    ;;
    "Disabled")
        xinput set-prop $id ${prop_ids[0]} 0
        echo
        echo "🔴 Disabled $prop_label"
    ;;
esac
