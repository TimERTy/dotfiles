#!/usr/bin/env bash
# Called by waypaper post_command with the selected wallpaper path as $1.
# Generates blurred/square wallpaper variants for hyprlock, then reloads the bar.

WALLPAPER="$1"
CACHE_DIR="$HOME/.cache/hypr"
mkdir -p "$CACHE_DIR"

echo "$WALLPAPER" > "$CACHE_DIR/current_wallpaper"

if command -v magick >/dev/null; then
    IM=(magick)
elif command -v convert >/dev/null; then
    IM=(convert)
else
    echo "wallpaper.sh: ImageMagick (magick or convert) not found" >&2
    exit 1
fi

# Blurred wallpaper for hyprlock background and rofi popup
"${IM[@]}" "$WALLPAPER" -resize 75% -blur 50x30 "$CACHE_DIR/blurred_wallpaper.png"

# Square crop for hyprlock avatar
"${IM[@]}" "$WALLPAPER" -gravity Center -extent 1:1 "$CACHE_DIR/square_wallpaper.png"

# Regenerate Material You palette for kitty/waybar/hypr/rofi/etc.
if command -v matugen >/dev/null; then
    matugen image "$WALLPAPER" -m dark -q
fi

# Reload waybar and swaync
~/.config/waybar/launch.sh &
sleep 0.5 && swaync-client -rs &
