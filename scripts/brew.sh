#!/bin/sh -xe

if ! [ -x "/usr/local/bin/brew" ] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# High Priority
brew install $(cat <<EOS | xargs
zsh
zsh-completions
keychain
readline
tmux
EOS
)

brew tap $(cat <<EOS | xargs
homebrew/cask-versions
heroku/brew
sachaos/todoist
EOS
)

# apps
for pkg in $(cat brew.cask.list|xargs)
do
  brew cask install  $pkg
done

# utilities
brew install $(cat brew.list|xargs)
