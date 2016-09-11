#!/bin/sh

ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

taps=<<EOL
phinze/homebrew-cask
osx-cross/avr
EOL

for tap in $taps
do
	brew tap $tap
done

brew_pkgs=<<EOL
ansible
avr-libc
boot2docker
brew-cask
bsdmake
cmake
coreutils
corkscrew
ctags
curl
docker
dfu-programmer
gettext
git
git-flow
gnu-sed
gnu-tar
go
gobject-introspection
grep
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
zsh
zsh-completions
EOL

for pkg in $brew_pkgs
do
	brew install $pkg
done

cask_pkgs=<<EOL
alfred
bettertouchtool
firefox
google-chrome
qlmarkdown
skype
vagrant
virtualbox
EOL

for pkg in $cask_pkgs
do
	brew cask install $pkg
done
