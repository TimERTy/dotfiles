#!/usr/bin/env bash
# Set wallpaper, regenerate Material You palette, reload session components.
# Works on Hyprland/Wayland (invoked by waypaper post_command) and Xorg
# (invoke directly: wallpaper.sh /path/to/img).

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

"${IM[@]}" "$WALLPAPER" -resize 75% -blur 50x30 "$CACHE_DIR/blurred_wallpaper.png"
"${IM[@]}" "$WALLPAPER" -gravity Center -extent 1:1 "$CACHE_DIR/square_wallpaper.png"

if command -v matugen >/dev/null; then
    matugen image "$WALLPAPER" -m dark -q
fi

case "${XDG_CURRENT_DESKTOP:-}" in
    *Hyprland*|*hyprland*)
        # waypaper set bg before invoking us; reload bar + notifs
        [ -x "$HOME/.config/waybar/launch.sh" ] && "$HOME/.config/waybar/launch.sh" &
        command -v swaync-client >/dev/null && (sleep 0.5 && swaync-client -rs) &
        ;;
    *GNOME*|*gnome*)
        # Ubuntu/GNOME: shell owns bar/notifs/lock; just set bg via gsettings
        if command -v gsettings >/dev/null; then
            uri="file://$WALLPAPER"
            gsettings set org.gnome.desktop.background picture-uri "$uri"
            gsettings set org.gnome.desktop.background picture-uri-dark "$uri"
            gsettings set org.gnome.desktop.background picture-options 'zoom'
        fi
        ;;
    *)
        # generic fallback
        command -v feh >/dev/null && feh --bg-fill "$WALLPAPER"
        ;;
esac
