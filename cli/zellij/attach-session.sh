#!/usr/bin/env bash

set -eo pipefail

zellij ls -ns | sort | gum filter --header "Attach session" --placeholder "Session name…" --no-fuzzy | xargs -r -n1 zellij attach
