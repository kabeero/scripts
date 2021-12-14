#!/usr/bin/env zsh
ONEDRIVE="/Users/mkgz/OneDrive/"
BOOKS="/Users/mkgz/Books"
DOCS="/Users/mkgz/Documents"
TUNES="/Users/mkgz/Music"
rsync -Pavu --exclude=.DS_Store --delete $BOOKS $ONEDRIVE
rsync -Pavu --exclude=.DS_Store --delete $DOCS  $ONEDRIVE
rsync -Pavu --exclude=.DS_Store          $TUNES $ONEDRIVE
