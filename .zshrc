# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

if [ -f ~/.shrc ]; then
    . ~/.shrc
fi

if [ -f ~/.sh_aliases ]; then
    . ~/.sh_aliases
fi
