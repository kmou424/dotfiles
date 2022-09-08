#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set PS1
PS1='[\u@\h \w]\$ '

# For list
alias ls='ls --color=auto'
alias lls='ls -ls --color=auto'
alias llsa='ls -lsa --color=auto'

# For pacman
alias pacclean='sudo pacman -Scc'
alias pacupgrade='sudo pacman -Syyu'
alias pacman='sudo pacman'

# Useful short name for some programs
alias pxc='proxychains'
alias hx='helix'

# Github proxy
ghProxyUrl=""

function getGhProxyUrl() {
    ghProxyUrl="https://ghproxy.com/${1}"
}

function wgetgh() {
    getGhProxyUrl $1
    wget "${ghProxyUrl}"
}

function ghclone() {
    getGhProxyUrl $1
    git clone "${ghProxyUrl}"
}
