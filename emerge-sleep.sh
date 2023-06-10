#!/usr/bin/env sh

trap exit SIGINT

E_PID=$(pgrep -af [e]merge | gum filter)
waitpid $E_PID
sleep 30
systemctl suspend
