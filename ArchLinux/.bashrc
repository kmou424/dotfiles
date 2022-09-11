#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set PS1
PS1='[\u@\h \w]\$ '

# Backup
PATH_BAK="${PATH}"

# For list
alias ls='ls --color=auto'
alias lls='ls -ls --color=auto'
alias llsa='ls -lsa --color=auto'

# For pacman
alias pacclean='sudo pacman -Scc'
alias pacupgrade='sudo pacman -Syyu'
alias pacman='sudo pacman'

# Git
alias gpick='git cherry-pick'

# Useful short name for some programs
alias df='df -h'
alias hx='helix'
alias supxc='sudo proxychains'
alias pxc='proxychains'
alias python='python3'

# External root (for personal build program)
export EXTERNAL_ROOT=~/external_root
export EXTERNAL_ROOT_BIN=$EXTERNAL_ROOT/bin
export EXTERNAL_ROOT_LIB=$EXTERNAL_ROOT/lib
export EXTRA_LD_LIBRARY_PATH=/usr/local/lib

# Make sure external root is available
if [ ! -d $EXTERNAL_ROOT_BIN ];then
    mkdir -p $EXTERNAL_ROOT_BIN
fi

if [ ! -d $EXTERNAL_ROOT_LIB ];then
    mkdir -p $EXTERNAL_ROOT_LIB
fi

# Prepare utils
if [ -f ~/.bashrc.d/utils.sh ];then
        chmod +x ~/.bashrc.d/utils.sh
        . ~/.bashrc.d/utils.sh
else
	return
fi

# Add external root into PATH
if [ "$(echo $PATH | grep ${EXTERNAL_ROOT_BIN} 2> /dev/null)" == "" ];then
    pathcat $EXTERNAL_ROOT_BIN
fi

# Add user-build programs lib to ld library path
if [ "$(echo $LD_LIBRARY_PATH | grep ${EXTRA_LD_LIBRARY_PATH} 2> /dev/null)" == "" ];then
    if [ "${LD_LIBRARY_PATH}" == "" ];then
        export LD_LIBRARY_PATH="${EXTRA_LD_LIBRARY_PATH}"
    else
        export LD_LIBRARY_PATH="${EXTRA_LD_LIBRARY_PATH}:${LD_LIBRARY_PATH}"
    fi
fi

# Add external root user-build programs lib to ld library path
if [ "$(echo $LD_LIBRARY_PATH | grep ${EXTERNAL_ROOT_LIB} 2> /dev/null)" == "" ];then
    if [ "${LD_LIBRARY_PATH}" == "" ];then
        export LD_LIBRARY_PATH="${EXTERNAL_ROOT_LIB}"
    else
        export LD_LIBRARY_PATH="${EXTERNAL_ROOT_LIB}:${LD_LIBRARY_PATH}"
    fi
fi

PATH_BAK=$PATH

# Execute other scripts
if [ -f ~/.bashrc.d/mount_smb.sh ];then
	chmod +x ~/.bashrc.d/mount_smb.sh
	. ~/.bashrc.d/mount_smb.sh
fi
