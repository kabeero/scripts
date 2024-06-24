#!/usr/bin/env bash

# macos not regaining DNS capabilities after VPN abrupt disconnect

option=$(
	gum choose \
		"1) configd" \
		"2) networksetup" \
		"3) flush DNS & restart mdns"
)

set -exo pipefail

case $option in
1*)
	sudo launchctl kickstart -k system/com.apple.configd
	;;
2*)
	sudo networksetup -setdnsservers Wi-Fi "Empty"
	;;
3*)
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
	;;
*)
	exit 1
	;;
esac
