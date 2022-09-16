#!/usr/bin/zsh

RCDOTD=.zshrc.d

if [ $1 = "install" ];then
	if [ -d ~/${RCDOTD} ];then
		if [ -d ~/${RCDOTD}.bak ];then
			rm -r ~/${RCDOTD}.bak
		fi
		mv ~/${RCDOTD} ~/${RCDOTD}.bak
	fi
	echo "Copying ${RCDOTD} ${HOME}/${RCDOTD}"
	cp -r ${RCDOTD} ~/${RCDOTD}
elif [ $1 = "update" ];then
	rm -r ${RCDOTD}
	echo "Copying ${HOME}/${RCDOTD} to ${RCDOTD}"
	cp -r ~/${RCDOTD} .
fi
