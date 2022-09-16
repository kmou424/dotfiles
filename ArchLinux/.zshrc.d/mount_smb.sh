#!/usr/bin/zsh

if [ -f ~/.zshrc.d/utils.sh ];then
        chmod +x ~/.zshrc.d/utils.sh
        . ~/.zshrc.d/utils.sh
else
        return
fi

mount_smb /home/kmou424/smb/kmou424 '\\192.168.2.42\kmou424'
