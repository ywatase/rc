#!/bin/sh

WORK_DIR=$(pwd)
SCRIPT_DIR=$(cd $(dirname $0); pwd)

cd $SCRIPT_DIR/../bundle/perl-support.vim/plugin/
patch < $SCRIPT_DIR/perl-support/perl-support.vim.patch
ln -s $HOME/.vim/bundle/perl-support.vim/perl-support/templates/idioms.template \
    $HOME/.vim/bundle_local/perl-support/templates/idioms.template
