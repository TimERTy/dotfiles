#!/bin/bash

DOT_DIR=$(pwd)
(
for i in $DOT_DIR\/{.*rc,.*aliases,.vim,.ctags}; do
    [ -e "$i" ] || continue
    i=${i##*/}
    rm -rf ~/$i
    ln -sf $DOT_DIR/$i ~/
done

)

