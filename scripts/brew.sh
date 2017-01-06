#!/bin/sh -xe

if ! [ -x "/usr/local/bin/brew" ] ; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

while read pkg
do
	brew install $pkg
done <<EOL
zsh
zsh-completions
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

while read pkg
do
	brew install $pkg
done <<EOL
ansible
osx-cross/avr/avr-libc
bsdmake
cmake
coreutils
corkscrew
ctags
curl
docker
dfu-programmer
gcc-arm-none-eabi
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
jmeter
jq
keychain
libevent
lynx
memcached
mongodb
msgpack
mysql
ngrep
nikto
nkf
nmap
openldap
openssh
openssl
packer
peco
percona-toolkit
perl-build
phantomjs
pidof
plenv
proctools
pstree
pyenv
qt
rdesktop
readline
reattach-to-user-namespace
redis
rename
rpm2cpio
sqlite
subversion
the_silver_searcher
tig
tmux
tree
wakeonlan
watch
wget
EOL


while read pkg
do
	brew cask install $pkg
done <<EOL
alfred
bettertouchtool
firefox
google-chrome
iterm2
qlmarkdown
skype
vagrant
virtualbox
EOL
