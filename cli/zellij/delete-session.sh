#!/usr/bin/env bash

set -eo pipefail

zellij ls -ns | sort | gum choose --header "Delete session" | xargs -r -n1 zellij delete-session --force
