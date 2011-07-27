#!/bin/sh

WORK_DIR=$(pwd)
SCRIPT_DIR=$(cd $(dirname $0); pwd)

cd $SCRIPT_DIR/../bundle/perl-support.vim/plugin/
patch < $SCRIPT_DIR/perl-support/perl-support.vim.patch
