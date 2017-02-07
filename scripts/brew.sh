#!/bin/sh -xe

if ! [ -x "/usr/local/bin/brew" ] ; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# High Priority
while read pkg
do
	brew install $pkg
done <<EOL
zsh
zsh-completions
keychain
readline
tmux
EOL

while read tap
do
	brew tap $tap
done <<EOL
phinze/homebrew-cask
PX4/homebrew-px4
osx-cross/avr
homebrew/dupes
EOL

# apps
while read pkg
do
	brew cask install $pkg
done <<EOL
alfred
firefox
google-chrome
iterm2
qlmarkdown
vagrant
virtualbox
xquartz
EOL


# utilities
while read pkg
do
	brew install $pkg
done <<EOL
ansible
bsdmake
cmake
coreutils
ctags
curl
dfu-programmer
gettext
git
git-flow
gnu-sed
gnu-tar
go
gobject-introspection
groff
harfbuzz
htop-osx
hub
imagemagick
innotop
memcached
mongodb
msgpack
mysql
ngrep
nikto
nkf
nmap
openssh
openssl
packer
percona-toolkit
perl-build
phantomjs
pidof
plenv
proctools
pstree
pyenv
reattach-to-user-namespace
redis
rename
rpm2cpio
sqlite
subversion
the_silver_searcher
tig
tree
wakeonlan
watch
w3m
wget
EOL


# need compile
brew install vim --with-lua

while read pkg
do
	brew install $pkg
done <<EOL
osx-cross/avr/avr-libc
gcc-arm-none-eabi
EOL
