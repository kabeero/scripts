#!/usr/bin/env zsh
osascript << EOF
tell application "System Preferences"
	activate
	reveal anchor "output" of pane id "com.apple.preference.sound"
	delay 0.5 -- If you get an error, it's possible this delay isn't long enough.
end tell
tell application "System Events"
	tell slider 1 of group 1 of tab group 1 of window 1 of process "System Preferences"
		set value to 0.5
	end tell
end tell
EOF
