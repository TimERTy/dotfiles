#!/bin/bash
set -e

usage() {
    cat <<EOF
Usage: $0 [--check-deps] [--theming-setup] [--no-theming-setup] [--help]

Stows dotfiles via GNU Stow. Optionally seeds the matugen palette by
running wallpaper.sh on a default wallpaper, and on GNOME hosts also
installs adw-gtk3 + flips gsettings so GTK3 apps follow the palette.

  --check-deps         List all dependencies with install status. No changes.
  --theming-setup      Run theming setup non-interactively.
  --no-theming-setup   Skip the theming prompt.
  --help               Show this message.
EOF
}

# ----- dependency table -----
# Each row: "label|category|hint|cmd1[ cmd2 ...]"
# Match if any cmd is on PATH (logical OR).
# Special label "theme:NAME" checks for GTK theme dir instead of command.
DEPS=(
    # core (install fails without these)
    "stow|core|GNU Stow (apt: stow / pacman: stow)|stow"
    "git|core||git"
    "zsh|core||zsh"

    # wallpaper + theming pipeline
    "imagemagick|theming|magick or convert (apt: imagemagick)|magick convert"
    "matugen|theming|cargo install matugen / AUR: matugen-bin|matugen"

    # Hyprland host
    "hyprland|hypr||hyprctl"
    "waybar|hypr||waybar"
    "waypaper|hypr|pip install waypaper|waypaper"
    "swaync|hypr||swaync swaync-client"
    "rofi-wayland|hypr||rofi"

    # Ubuntu/GNOME host
    "gsettings|gnome|libglib2.0-bin|gsettings"
    "theme:adw-gtk3-dark|gnome|apt install adw-gtk3|"

    # optional / cross-session
    "kitty|optional||kitty"
    "ghostty|optional||ghostty"
    "btop|optional||btop"
    "nvim|optional||nvim"
    "tmux|optional||tmux"
    "feh|optional|fallback X11 wallpaper setter|feh"
)

check_one() {
    # echoes "OK <found>" or "MISS <hint>"
    local label="$1" hint="$2" cmds="$3"
    if [[ "$label" == theme:* ]]; then
        local name="${label#theme:}"
        for d in "/usr/share/themes/$name" "$HOME/.themes/$name" "$HOME/.local/share/themes/$name"; do
            [ -d "$d" ] && { echo "OK $d"; return 0; }
        done
        echo "MISS ${hint:-not installed}"
        return 1
    fi
    for cmd in $cmds; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "OK $(command -v "$cmd")"
            return 0
        fi
    done
    echo "MISS ${hint:-not installed}"
    return 1
}

show_deps() {
    local last_cat=""
    local missing_core=0 missing_total=0
    for row in "${DEPS[@]}"; do
        IFS='|' read -r label cat hint cmds <<<"$row"
        if [ "$cat" != "$last_cat" ]; then
            # printf "\n== %s ==\n" "$cat"
            last_cat="$cat"
        fi
        local result; result=$(check_one "$label" "$hint" "$cmds") || true
        local status="${result%% *}"
        local detail="${result#* }"
        if [ "$status" = "OK" ]; then
            printf "  [✓] %-22s %s\n" "$label" "$detail"
        else
            # printf "  [ ] %-22s %s\n" "$label" "$detail"
            missing_total=$((missing_total+1))
            [ "$cat" = "core" ] && missing_core=$((missing_core+1))
        fi
    done
    echo
    if [ "$missing_total" -eq 0 ]; then
        echo "All dependencies present."
    else
        echo "$missing_total missing ($missing_core core)."
    fi
    return "$missing_core"
}

CHECK_DEPS=no
THEMING_SETUP=auto
for arg in "$@"; do
    case "$arg" in
        --check-deps)        CHECK_DEPS=yes ;;
        --theming-setup)     THEMING_SETUP=yes ;;
        --no-theming-setup)  THEMING_SETUP=no ;;
        --help|-h)           usage; exit 0 ;;
        *) echo "unknown arg: $arg" >&2; usage; exit 2 ;;
    esac
done

if [ "$CHECK_DEPS" = yes ]; then
    show_deps
    exit $?
fi

# ----- preflight: only stow is hard-required -----
if ! command -v stow >/dev/null; then
    echo "ERROR: GNU Stow not found. Install via:" >&2
    echo "  apt install stow   # Debian/Ubuntu" >&2
    echo "  pacman -S stow     # Arch/CachyOS" >&2
    echo "  dnf install stow   # Fedora" >&2
    exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

stow -t "$HOME" --adopt home
stow -t "$HOME" home

# --- Optional: GNOME GTK theming setup (adw-gtk3 + gsettings) ---
adw_gtk3_already_installed() {
    [ -d "/usr/share/themes/adw-gtk3" ] \
        || [ -d "$HOME/.local/share/themes/adw-gtk3" ] \
        || [ -d "$HOME/.themes/adw-gtk3" ]
}

install_adw_gtk3_user() {
    # Fallback: download latest GitHub release tarball into ~/.local/share/themes
    echo "    installing adw-gtk3 to ~/.local/share/themes (user-local)"
    command -v curl  >/dev/null || { echo "    curl missing" >&2; return 1; }
    command -v tar   >/dev/null || { echo "    tar missing"  >&2; return 1; }

    local url tmp
    url=$(curl -sL https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest \
          | grep -oE 'https://github\.com/[^"]+adw-gtk3[^"]+\.tar\.xz' | head -1)
    [ -n "$url" ] || { echo "    could not find release URL" >&2; return 1; }

    tmp=$(mktemp -d) || return 1
    trap "rm -rf '$tmp'" RETURN
    if ! curl -sL -o "$tmp/adw-gtk3.tar.xz" "$url"; then
        echo "    download failed: $url" >&2
        return 1
    fi
    mkdir -p "$HOME/.local/share/themes"
    tar -xf "$tmp/adw-gtk3.tar.xz" -C "$HOME/.local/share/themes" \
        || { echo "    tar extract failed" >&2; return 1; }
    echo "    installed from $url"
}

install_adw_gtk3_pkg() {
    # No `apt-get update` — avoids /var/lib/apt/lists/lock contention with
    # unattended-upgrades, and on Ubuntu adw-gtk3 isn't in the repos anyway
    # so the install will quickly fall through to the GitHub fallback.
    if command -v apt-get >/dev/null; then
        sudo apt-get install -y adw-gtk3 >/dev/null 2>&1
    elif command -v dnf >/dev/null; then
        sudo dnf install -y adw-gtk3 >/dev/null 2>&1
    elif command -v pacman >/dev/null; then
        sudo pacman -S --needed --noconfirm adw-gtk3 >/dev/null 2>&1
    else
        return 1
    fi
}

gnome_setup() {
    echo "==> GNOME GTK setup: installing adw-gtk3 and switching theme"

    if adw_gtk3_already_installed; then
        echo "    adw-gtk3 already installed"
    elif install_adw_gtk3_pkg; then
        echo "    adw-gtk3 installed via package manager"
    else
        echo "    package manager install failed (not in repos); falling back"
        install_adw_gtk3_user || {
            echo "    adw-gtk3 install failed; theme switch skipped" >&2
            return 1
        }
    fi

    if command -v gsettings >/dev/null; then
        gsettings set org.gnome.desktop.interface gtk-theme    'adw-gtk3-dark'
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        echo "    gtk-theme=adw-gtk3-dark, color-scheme=prefer-dark"
    else
        echo "    gsettings not found; skipping theme switch" >&2
    fi
}

is_gnome() { [[ "${XDG_CURRENT_DESKTOP:-}" =~ [Gg][Nn][Oo][Mm][Ee] ]]; }

theming_setup() {
    echo "==> Theming setup"

    if ! command -v matugen >/dev/null; then
        echo "    matugen not found — palette seeding skipped." >&2
        echo "    Install: cargo install matugen  (or AUR: matugen-bin)" >&2
    else
        local wall_dir="$HOME/.config/wallpapers" wall=""
        for c in "$wall_dir/default.jpg" "$wall_dir/default.png"; do
            [ -f "$c" ] && wall="$c" && break
        done
        if [ -z "$wall" ]; then
            wall=$(find "$wall_dir" -maxdepth 2 -type f \
                \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
                2>/dev/null | sort | head -1)
        fi
        if [ -z "$wall" ]; then
            echo "    no wallpaper in $wall_dir; skipping palette seed" >&2
        else
            echo "    seeding palette from: $wall"
            "$HOME/.local/bin/set-wallpaper" "$wall" \
                || echo "    set-wallpaper failed; templates may be empty" >&2
        fi
    fi

    if is_gnome; then
        gnome_setup
    else
        echo "    non-GNOME host; skipping adw-gtk3/gsettings step"
    fi
}

case "$THEMING_SETUP" in
    yes) theming_setup ;;
    no)  ;;
    auto) ;;
esac

# --- post-install dep summary (non-fatal) ---
echo
echo "==> Dependency check (non-core missing items only warn):"
show_deps || true
