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

cd ~/.vim/bundle/
git clone https://github.com/vim-scripts/paredit.vim.git || (cd paredit.vim; git pull)
git clone https://github.com/zhaocai/GoldenView.Vim.git || (cd GoldenView.Vim; git pull)
)

