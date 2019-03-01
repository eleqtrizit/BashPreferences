#!/bin/sh

currentDir=$(pwd)

chmod 755 color
M=$(color 129)
W=$(color 255)
R=$(color 196)

APTUPDATED=0

if [ "$(id -u)" -ne 0 ]; then
        echo ${R}Please execute this as "${W}sudo sh setup.sh${R}"${W}
	exit;
fi

exitWithError() {
	echo "$1"
	exit 1
}

aptUpdate () {
	if [ $APTUPDATED -ne 1 ]; then
		echo ${M}Updating repos${W}
		echo apt update
		echo apt -y upgrade
		echo apt -y install git
		APTUPDATED=1
	fi
}

makeDir () {
	if [ ! -d "$1" ]; then
		mkdir -p "$1"
	fi
}

checkPackage() {
	echo ${M}Checking for "$1".${W}
	var=$(sh get-list-of-installed-packages.sh | grep "$1" | grep -v man)
	if [ -z "$var" ]
	then
	        echo ${M}"$1" is not installed.
	        echo Correcting...
	        aptUpdate
		apt install "$1"
	else
	      echo ${M}"$1" is installed${W}
	fi
}


echo ${M}Making scripts executable.${W}
chmod 755 get-list-of-installed-packages.sh
chmod 755 coloroptions
chmod 755 coloroptions_ansi

checkPackage git
checkPackage vim

echo ${M}Installing VIM colors${W}
makeDir ~/.vim
cd ~ || exit
git clone https://github.com/flazz/vim-colorschemes.git ~/.vim
cd $currentDir || exit
cp molokai_black.vim ~/.vim/colors/

cp vimrc ~/.vimrc

cat bashrc_append >> ~/.bashrc

echo ${R}Type ${W}source ~/.bashrc ${R}to activate new prompt!

