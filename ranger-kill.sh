#!/usr/bin/env sh
ps aux | grep -i ranger | gum choose | awk '{print }' | xargs -n1 kill -9
