#!/usr/bin/env sh

# osascript << EOF
# tell application "System Preferences"
# 	activate
# 	reveal anchor "MenuBar" of pane id "com.apple.ControlCenter-Settings.extension"
# 	delay 1.0 -- If you get an error, it's possible this delay isn't long enough.
# end tell
# tell application "System Events"
# 	tell menu 4 of group 3 of tab group 1 of window 1 of process "System Settings"
# 		click menu item 1 of menu 4
# 	end tell
# end tell
# EOF

# defaults write NSGlobalDomain _HIHideMenuBar -bool false

VALUE=$(defaults read NSGlobalDomain _HIHideMenuBar)
case "$VALUE" in
    1) echo "🔶 Showing menubar"
       defaults write NSGlobalDomain _HIHideMenuBar -bool false
    ;;
    0) echo "🔶 Hiding menubar"
       defaults write NSGlobalDomain _HIHideMenuBar -bool true
    ;;
    *) echo "❗ Unknown value for menubar"
    ;;
esac

killall Finder
sleep .25

echo "🔶 hide menubar: $(defaults read NSGlobalDomain _HIHideMenuBar)"
