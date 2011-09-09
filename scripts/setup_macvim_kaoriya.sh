#!/bin/bash

CURRENT_DIR=$(pwd)
DIR=$(cd $(dirname $0); pwd)

get_filename () {
	for FNAME in view vim vimdiff vimex
	do
		echo "$FNAME m$FNAME"
	done
}

if [ "x$1" = "xsetup" ] ; then
	for FNAME in `get_filename`
	do
		ln -s $DIR/../bin/mvim $HOME/bin/$FNAME
    done
elif [ "x$1" = "xclean" ] ; then
	for FNAME in `get_filename`
	do
	  rm $HOME/bin/$FNAME 
    done
else
	cat <<END
$(basename $0) setup|clean - setup macvim kaoriya edition

  setup - make symlink
  clean - remove symlink
END
fi



