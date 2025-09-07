#!/bin/bash

if ! type "stow" > /dev/null 2>&1;then
    echo "stow not installed"
    exit 0;
fi

stow .config -t ~/.config
stow .
