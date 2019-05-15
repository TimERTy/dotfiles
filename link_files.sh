#!/bin/bash

DOT_DIR=$(pwd)
(
rm -rf ~/.zshrc
ln -s $DOT_DIR/.zshrc ~/

rm -rf ~/.bashrc
ln -s $DOT_DIR/.bashrc ~/

rm -rf ~/.shrc
ln -s $DOT_DIR/.shrc ~/

rm -rf ~/.sh_aliases
ln -s $DOT_DIR/.sh_aliases ~/

rm -rf ~/.vim
ln -s $DOT_DIR/.vim ~/

rm -rf ~/.vimrc
ln -s $DOT_DIR/.vimrc ~/

rm -rf ~/.zprezto/modules/prompt/functions/prompt_timerty_setup
ln -s $DOT_DIR/prompt_timerty_setup ~/.zprezto/modules/prompt/functions/

rm -rf ~/.config/kglobalshortcutsrc
ln -s $DOT_DIR/kglobalshortcutsrc ~/.config/
)

