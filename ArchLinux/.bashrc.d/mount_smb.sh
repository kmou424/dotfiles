#!/usr/bin/bash

if [ -f ~/.bashrc.d/utils.sh ];then
        chmod +x ~/.bashrc.d/utils.sh
        . ~/.bashrc.d/utils.sh
else
        return
fi

mount_smb /home/kmou424/smb/kmou424 '\\192.168.2.42\kmou424'
