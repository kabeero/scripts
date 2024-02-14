#!/usr/bin/env bash

# macos not regaining DNS capabilities after VPN abrupt disconnect

option=$(
	gum choose \
		"1) configd" \
		"2) networksetup"
)

set -exo pipefail

case $option in
1*)
	sudo launchctl kickstart -k system/com.apple.configd
	;;
2*)
	sudo networksetup -setdnsservers Wi-Fi "Empty"
	;;
*)
	exit 1
	;;
esac
