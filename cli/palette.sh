#!/usr/bin/env bash

# Color Palette Preview Script
# This script displays a visual preview of color combinations in the terminal
echo "=== Terminal Color Palette Preview ==="
echo
# Function to display a color swatch with text
show_color_swatch() {
    local bg_code=$1
    local text_code=$2
    local color_name=$3

    echo -e "\033[${bg_code};${text_code}m ${color_name} \033[0m"
}
# Standard colors (30-37)
echo "Standard Colors:"
for i in {30..37}; do
    case $i in
    30) color="Black" ;;
    31) color="Red" ;;
    32) color="Green" ;;
    33) color="Yellow" ;;
    34) color="Blue" ;;
    35) color="Magenta" ;;
    36) color="Cyan" ;;
    37) color="White" ;;
    esac
    echo -e "\033[${i}m${color}\033[0m"
done
echo
# Bright colors (90-97)
echo "Bright Colors:"
for i in {90..97}; do
    case $((i - 89)) in
    1) color="Black" ;;
    2) color="Red" ;;
    3) color="Green" ;;
    4) color="Yellow" ;;
    5) color="Blue" ;;
    6) color="Magenta" ;;
    7) color="Cyan" ;;
    8) color="White" ;;
    esac
    echo -e "\033[${i}m${color}\033[0m"
done
echo
# Background colors (40-47)
echo "Background Colors:"
for i in {40..47}; do
    case $i in
    40) color="Black" ;;
    41) color="Red" ;;
    42) color="Green" ;;
    43) color="Yellow" ;;
    44) color="Blue" ;;
    45) color="Magenta" ;;
    46) color="Cyan" ;;
    47) color="White" ;;
    esac
    echo -e "\033[${i}m ${color} \033[0m"
done
echo
# Combinations of foreground and background colors
echo "Color Combinations:"
for bg in {40..47}; do
    for fg in {30..37}; do
        # Skip when bg and fg are the same (invisible text)
        if [ $bg -ne $fg ]; then
            printf "\033[${bg};${fg}m %2d;%2d \033[0m" $bg $fg
        else
            printf "      "
        fi
    done
    echo
done
echo
# 256-color palette preview (first 16 colors)
echo "256-Color Palette (First 16):"
for i in {0..15}; do
    printf "\033[48;5;%dm %3d \033[0m" $i $i
    if [ $(((i + 1) % 8)) -eq 0 ]; then
        echo
    fi
done
echo
# Custom color palette example
echo "Custom Color Palette Example:"
declare -A custom_colors=(
    ["Primary"]="#2563EB"
    ["Secondary"]="#7C3AED"
    ["Accent"]="#DB2777"
    ["Success"]="#10B981"
    ["Warning"]="#F59E0B"
    ["Error"]="#EF4444"
    ["Info"]="#3B82F6"
    ["Neutral"]="#6B7280"
)
# Display custom colors with simulated previews
for name in "${!custom_colors[@]}"; do
    echo -e "\033[1m${name}:\033[0m ${custom_colors[$name]}"
done
