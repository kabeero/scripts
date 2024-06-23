#!/usr/bin/env bash

set -eo pipefail

zellij ls -ns | sort | gum choose --header "Attach session" | xargs -r -n1 zellij attach
