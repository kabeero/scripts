#!/usr/bin/env bash

# toggle kitty's theme, selector, light or dark, or fix tabs

set -euo pipefail

# DARKMODE="noirblaze"
DARKMODE="Dark Pride"
LIGHTMODE="GitHub Light"

cmds=("kitty" "gum")
for c in "${cmds[@]}"; do
	if [[ ! $(command -v "$c") ]]; then
		echo "Please install $c"
		exit 1
	fi
done

reload_kitty() {
	pgrep -af kitty | grep "[k]itty -1" | awk '{print $1}' | xargs -n1 kill -USR1
}

fix_tabs() {
	cat <<EOF >>"${HOME}/.config/kitty/current-theme.conf"
active_tab_background   #111
active_tab_foreground   #fff
inactive_tab_background #222
inactive_tab_foreground #666
tab_bar_background      none
EOF
	reload_kitty
}

if [[ $# -eq 0 ]]; then
	# mode=$(gum choose "Light" "Dark")
	kitty +kitten themes
	exit 0
else
	mode=$1
fi

mkdir -p "${HOME}/.config/bat"

case $mode in
Li* | l*)
	echo "Using light mode"
	kitty +kitten themes "$LIGHTMODE"
	echo "--theme=OneHalfLight" >"${HOME}/.config/bat/config"
	;;
Da* | d*)
	echo "Using dark mode"
	kitty +kitten themes "$DARKMODE"
	echo "--theme=TwoDark" >"${HOME}/.config/bat/config"
	fix_tabs
	;;
T* | t*)
	echo "Fixing tab colors"
	fix_tabs
	;;
*)
	echo "Unknown theme"
	;;
esac
