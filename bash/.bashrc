#!/usr/bin/env bash
# Environment
export EDITOR='emacsclient -nw'
export VISUAL="${EDITOR}"
export ALTERNATE_EDITOR='emacs -nw'

export LSCOLORS='gxfxbEaEBxxEhEhBaDaCaD'
export LS_COLORS='di=36:ln=35:so=31;1;44:pi=30;1;44:ex=1;31:bd=0;1;44:cd=37;1;44:su=37;1;41:sg=30;1;43:tw=30;1;42:ow=30;1;43'

export LESS='-RSi'

# Prompt
RED="\[$(tput setaf 1)\]"
GREEN="\[$(tput setaf 2)\]"
YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
MAGENTA="\[$(tput setaf 5)\]"
CYAN="\[$(tput setaf 6)\]"
NORMAL="\[$(tput sgr0)\]"

export PS1="\n${BLUE}\u${CYAN}@${BLUE}\H${CYAN}:${GREEN}\w\n${MAGENTA}\$ ${NORMAL}"
export PS2="${MAGENTA}> ${NORMAL}"

# Aliases
if ls --color=auto &> /dev/null; then
    LS_FLAGS='--color=auto'
else
    LS_FLAGS='-G'
fi
alias ls="ls ${LS_FLAGS}"
alias ll="ls -l ${LS_FLAGS}"
alias la="ls -la ${LS_FLAGS}"

if [ -x /usr/local/bin/mvim ]; then
    alias vim='mvim -v'
    alias vimdiff='mvim -v -d'
fi

alias ect='emacsclient -nw'
alias ecx='emacsclient -n -c'

alias cget='curl -O'

# Completion
if [ -r /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
elif [ -r /etc/bash_completion ]; then
    source /etc/bash_completion
fi
