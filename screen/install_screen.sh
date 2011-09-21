#!/bin/sh

SCRIPT_DIR=`pwd`/`dirname $0`

cd $SCRIPT_DIR

# http://www.dekaino.net/screen/01install.html
for PATCH_NAME in screen-4.0.2-deadlock-patch screen-4.0.2-hankanacopy-patch ftp://www.dekaino.net/pub/screen/screen-4.0.2-patch-cjkwidth-cvs-2006052001
do 
	if ! [ -e $SCRIPT_DIR/patches/$PATCH_NAME  ] ; then
		curl -LO http://www.dekaino.net/pub/screen/$PATCH_NAME
	fi
done

# https://savannah.gnu.org/git/?group=screen
if [ -d screen ] ; then
	cd screen/src
	git pull
else
	git clone git://git.savannah.gnu.org/screen.git
	cd screen/src
fi


patch < $SCRIPT_DIR/patches/screen-4.0.2-deadlock-patch
patch < $SCRIPT_DIR/patches/screen-4.0.2-hankanacopy-patch

autoconf
autoheader
./configure
make && sudo make install
