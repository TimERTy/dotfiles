#!/bin/bash

DOT_DIR=$(pwd)
(
for i in $DOT_DIR\/{.*rc,.*aliases,.vim,.ctags}; do
    [ -e "$i" ] || continue
    i=${i##*/}
    rm -rf ~/$i
    ln -sf $DOT_DIR/$i ~/
done

echo -n "Setup zsh and zprezto? [Y/n]: "
read ans
if [[ $ans != "n" ]] && [[ $ans != "no" ]] && [[ $ans != "No" ]]; then
    if [[ ! -d ~/.zprezto ]]; then
        #install zpresto
        sudo apt install -y zsh
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
        /bin/zsh -i -c '
            setopt EXTENDED_GLOB;
            for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
                ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            done'
        chsh -s /bin/zsh
    fi
    rm -rf ~/.zprezto/modules/prompt/functions/prompt_timerty_setup
    ln -sf $DOT_DIR/prompt_timerty_setup ~/.zprezto/modules/prompt/functions/
fi

)

