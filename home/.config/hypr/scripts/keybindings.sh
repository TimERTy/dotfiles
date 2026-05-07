#!/usr/bin/env bash
# Show Hyprland keybindings in rofi.
# Parses ~/.config/hypr/keybindings.conf and renders one row per `bind*=` line.
# Each row: "MOD + KEY \r  description" — \r hides the description from search.

set -u

CONFIG="$HOME/.config/hypr/keybindings.conf"
echo "Reading from: $CONFIG"

rendered=$(awk '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }

    BEGIN {
        # Replacement table — applied in declared order; longest prefixes first.
        n = 0
        from[++n] = "\\$mainMod_L";          to[n] = "SUPER_L"
        from[++n] = "\\$mainMod_R";          to[n] = "SUPER_R"
        from[++n] = "\\$mainMod";            to[n] = "SUPER"

        from[++n] = "bracketleft";           to[n] = "["
        from[++n] = "bracketright";          to[n] = "]"
        from[++n] = "comma";                 to[n] = ","

        from[++n] = "XF86AudioRaiseVolume";  to[n] = "FN_VOLUME_UP"
        from[++n] = "XF86AudioLowerVolume";  to[n] = "FN_VOLUME_DOWN"
        from[++n] = "XF86AudioMicMute";      to[n] = "FN_MIC_MUTE"
        from[++n] = "XF86AudioMute";         to[n] = "FN_MUTE"
        from[++n] = "XF86Sleep";             to[n] = "FN_SLEEP"
        from[++n] = "XF86Rfkill";            to[n] = "FN_AIRPLANE_MODE"
        from[++n] = "XF86AudioPlayPause";    to[n] = "FN_PLAY_PAUSE"
        from[++n] = "XF86AudioPause";        to[n] = "FN_PAUSE"
        from[++n] = "XF86AudioPlay";         to[n] = "FN_PLAY"
        from[++n] = "XF86AudioNext";         to[n] = "FN_NEXT_TRACK"
        from[++n] = "XF86AudioPrev";         to[n] = "FN_PREVIOUS_TRACK"
        from[++n] = "XF86AudioStop";         to[n] = "FN_STOP"
        from[++n] = "XF86Calculator";        to[n] = "FN_CALCULATOR"
        from[++n] = "XF86_ScreenSaver";      to[n] = "LOCK_SCREEN"
        from[++n] = "XF86MonBrightnessUp";   to[n] = "FN_BRIGHTNESS_UP"
        from[++n] = "XF86MonBrightnessDown"; to[n] = "FN_BRIGHTNESS_DOWN"

        repl_count = n
        row = 0
    }

    # Match any bind variant (bind, bindl, binde, bindm, ...).
    $1 ~ /^bind[[:alpha:]]*/ {
        line = $0

        # Pull trailing comment as the human-readable description.
        desc = ""
        if (match(line, /#[[:space:]]*(.*)$/, m)) {
            desc = m[1]
            gsub(/^[! ]+|[! ]+$/, "", desc)
            sub(/[ \t]*#.*/, "", line)
        }

        # Strip "bindXY = " prefix and split CSV right-hand side.
        sub(/^bind[[:alpha:]]*[[:space:]]*=+[[:space:]]*/, "", line)
        parts_n = split(trim(line), parts, /[ \t]*,[ \t]*/)

        mods       = trim(parts[1])
        key        = (parts_n >= 2) ? trim(parts[2]) : ""
        dispatcher = (parts_n >= 3) ? trim(parts[3]) : ""

        # Remaining CSV fields are dispatcher arguments.
        params = ""
        for (j = 4; j <= parts_n; j++) {
            p = trim(parts[j])
            if (p != "") params = (params ? params ", " : "") p
        }

        # Apply substitutions to mods + key.
        for (i = 1; i <= repl_count; i++) {
            gsub(from[i], to[i], mods)
            gsub(from[i], to[i], key)
        }

        gsub(/[ \t]+/, " + ", mods)
        mods = toupper(mods)
        key  = toupper(key)

        # Drop redundant "MOD + MOD_L" style entries.
        if (key == mods "_L" || key == mods "_R") key = ""

        if (mods && key)      combo = mods " + " key
        else if (key)         combo = key
        else                  combo = mods

        # Description fallback chain: comment > dispatcher+args > dispatcher only.
        if (desc != "")             description = desc
        else if (dispatcher && params) description = dispatcher " " params
        else                        description = dispatcher

        row++
        combos[row]       = combo
        descriptions[row] = description
    }

    END {
        for (i = 1; i <= row; i++) {
            if (descriptions[i] != "")
                print combos[i] "\r  " descriptions[i]
            else
                print combos[i]
        }
    }
' "$CONFIG")

sleep 0.2

rofi -dmenu -i -markup -eh 2 -replace -p "Keybinds" \
    -config ~/.config/rofi/config-compact.rasi <<<"$rendered"
