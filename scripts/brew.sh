#!/bin/sh

ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

brew tap phinze/homebrew-cask
brew install brew-cask

pkgs=<<EOL
alfred 
bettertouchtool
firefox
google-chrome
qlmarkdown
skype
vagrant
virtualbox
EOL

for pkg in $pkgs
do
	brew cask install $pkg
done
