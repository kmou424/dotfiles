#!/usr/bin/bash

if [ $1 == "install" ];then
	if [ -d ~/.bashrc.d ];then
		if [ -d ~/.bashrc.d.bak ];then
			rm -r ~/.bashrc.d.bak
		fi
		mv ~/.bashrc.d ~/.bashrc.d.bak
	fi
	echo "Copying .bashrc.d ${HOME}/.bashrc.d"
	cp -r .bashrc.d ~/.bashrc.d
elif [ $1 == "update" ];then
	rm -r .bashrc.d
	echo "Copying ${HOME}/.bashrc.d to .bashrc.d"
	cp -r ~/.bashrc.d .
fi
