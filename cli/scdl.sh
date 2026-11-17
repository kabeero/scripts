#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="${SOUNDCLOUD_DIR:-$HOME/Downloads/SoundCloud}"
BROWSER="${SOUNDCLOUD_BROWSER:-firefox}"

usage() {
    cat <<EOF
Usage: $(basename "$0") <url> [url2 ...]

Downloads SoundCloud tracks/playlists in the highest available quality
with embedded artwork and metadata using your $BROWSER browser session.

Destination: $DEST_DIR

Options can be customized via environment variables:
  SOUNDCLOUD_DIR      Destination directory (default: ~/Downloads/SoundCloud)
  SOUNDCLOUD_BROWSER  Browser for cookies (default: firefox)
EOF
    exit 1
}

if [ "$#" -lt 1 ]; then
    usage
fi

mkdir -p "$DEST_DIR"

for url in "$@"; do
    echo "================================================================="
    echo "Processing: $url"
    echo "================================================================="

    echo ""
    echo "--- Available Formats & Qualities ($BROWSER session) ---"
    yt-dlp --cookies-from-browser "$BROWSER" -F "$url"

    echo ""
    echo "--- Downloading Best Quality Audio to $DEST_DIR ---"
    yt-dlp \
        --cookies-from-browser "$BROWSER" \
        -x \
        -N 4 \
        --audio-format m4a \
        --embed-thumbnail \
        --embed-metadata \
        --force-overwrites \
        -P "$DEST_DIR" \
        -o "%(title)s.%(ext)s" \
        "$url"

    echo ""
    echo "Done: $url"
    echo "================================================================="
    echo ""
done
