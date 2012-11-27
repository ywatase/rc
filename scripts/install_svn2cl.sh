#!/bin/sh

SVN2CL_VERSION=0.13
INSTALL_DIR=~/bin/src
[ -e $INSTALL_DIR ] || mkdir -p $INSTALL_DIR
cd $INSTALL_DIR
wget http://arthurdejong.org/svn2cl/svn2cl-${SVN2CL_VERSION}.tar.gz
tar xzf svn2cl-${SVN2CL_VERSION}.tar.gz
ln -s $INSTALL_DIR/svn2cl-${SVN2CL_VERSION}/svn2cl.sh ~/bin/svn2cl
