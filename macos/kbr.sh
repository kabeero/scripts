#!/usr/bin/env sh

# > https://mac-key-repeat.zaymon.dev/

# 120 ms / 60 ms
defaults write -g InitialKeyRepeat -int 8
defaults write -g KeyRepeat -int 4

# # 180 ms / 30 ms
# defaults write -g InitialKeyRepeat -int 12 ;
# defaults write -g KeyRepeat -int 2 ;

defaults write -g ApplePressAndHoldEnabled -bool false
