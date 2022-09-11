#!/usr/bin/bash

if [ $1 == "install" ];then
	if [ -f ~/.bashrc ];then
		if [ -f ~/.bashrc.bak ];then
			rm ~/.bashrc.bak
		fi
		mv ~/.bashrc ~/.bashrc.bak
	fi
	if [ -d ~/.bashrc.d ];then
		if [ -d ~/.bashrc.d.bak ];then
			rm -r ~/.bashrc.d.bak
		fi
		mv ~/.bashrc.d ~/.bashrc.d.bak
	fi
	echo "Copying .bashrc to ${HOME}/.bashrc"
	cp .bashrc ~/.bashrc
	echo "Copying .bashrc.d ${HOME}/.bashrc"
	cp -r .bashrc.d ~/.bashrc.d
elif [ $1 == "update" ];then
	rm .bashrc
	rm -r .bashrc.d
	echo "Copying ${HOME}/.bashrc to .bashrc"
	cp ~/.bashrc .
	echo "Copying ${HOME}/.bashrc.d to .bashrc.d"
	cp -r ~/.bashrc.d .
fi
