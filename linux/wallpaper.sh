#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/backgrounds"

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

# Fetch all valid images into an array safely handling spaces
mapfile -t images < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \))

if [ ${#images[@]} -eq 0 ]; then
    echo "No images found in $WALLPAPER_DIR"
    sleep 60
    continue
fi

# Get the list of currently active monitors from hyprctl
mapfile -t monitors < <(hyprctl monitors | grep "Monitor" | awk '{print $2}')

used_images=()

for monitor in "${monitors[@]}"; do
    # Pick a random image that hasn't been used for another monitor in this cycle
    while true; do
        random_img="${images[RANDOM % ${#images[@]}]}"
        if [[ ! " ${used_images[*]} " =~ " ${random_img} " ]] || [ ${#images[@]} -le ${#monitors[@]} ]; then
            break
        fi
    done

    used_images+=("$random_img")

    # Send to awww with a smooth step transition
    awww img -o "$monitor" "$random_img" --transition-type fade --transition-fps 60 --transition-step 2
done
