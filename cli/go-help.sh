#!/usr/bin/env bash

set -eou pipefail

for cmd in "go" "glow" "gum"; do
	if [ ! -x "$(command -v $cmd)" ]; then
		echo "Please install $cmd"
		exit 1
	fi
done

if [ ! -e go.mod ]; then
	HELP_MOD=$(gum input --header "Enter module for docs" --placeholder="")
else
	if [ $# -gt 0 ]; then
		MOD=""
		HELP_MOD=$(
			grep -E "^require" <go.mod |
				sed -e 's/require //; s$ // indirect$$; s$ .*$$' |
				gum choose
		)

		if [[ -n $MOD ]]; then
			HELP_MOD="$HELP_MOD/$MOD"
		fi

		HELP_MOD=$(
			gum input \
				--header "🔍 Module to lookup" \
				--value="$HELP_MOD"
		)
	fi
fi

go doc "$HELP_MOD" | glow -p
