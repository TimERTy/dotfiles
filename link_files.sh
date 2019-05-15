#!/bin/bash

DOT_DIR=$(pwd)
(
for i in $DOT_DIR\/{.*rc,.*aliases,.vim}; do
    [ -e "$i" ] || continue
    i=${i##*/}
    rm -rf ~/$i
    ln -sf $DOT_DIR/$i ~/
done

if [[ -d ~/.zprezto ]]; then
    rm -rf ~/.zprezto/modules/prompt/functions/prompt_timerty_setup
    ln -sf $DOT_DIR/prompt_timerty_setup ~/.zprezto/modules/prompt/functions/
fi

if [[ -e ~/.config/kglobalshortcutsrc ]]; then
    rm -rf ~/.config/kglobalshortcutsrc
    ln -sf $DOT_DIR/kglobalshortcutsrc ~/.config/
fi
)

