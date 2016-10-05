#!/bin/sh
sudo apt-get update
sudo apt-get install -y keychain silversearcher-ag
sudo apt-get install -y lightdm awesome xorg gnome-terminal
sudo apt-get install -y zsh tmux vim-common
# font
sudo apt-get install -y fonts-dejavu-core fonts-droid \
	fonts-freefont-ttf \
	fonts-ipafont fonts-ipafont-gothic fonts-ipafont-mincho \
	fonts-liberation fonts-ricty-diminished \
	xfonts-base xfonts-encodings xfonts-scalable xfonts-terminus xfonts-unifont xfonts-utils
# ruby
sudo apt-get install -y build-essential bison openssl readline-common \
   libreadline-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev \
   libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf \
   libc6-dev ncurses-dev autoconf bison \
   libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

# python
sudo apt-get install -y libbz2-dev libsqlite3-dev libssl-dev zlib1g-dev libreadline-dev

# Japanese
sudo apt-get install -y task-japanese-desktop
