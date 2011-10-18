#!/bin/sh

# <+FILE NAME+>
#   Purpose: skelton of shell script
#
#   Author: <+AUTHOR+> <<+EMAIL+>>
#   Create Date:   <+DATE+>
#   Last Modified: 2011/09/29.

FLAG_DEBUG=
MAILTO=

VERSION=0.1

main () {
  init $@

  # write here
}

init () {
  while getopts 'Dm:v' opt
  do
    case $opt in
      D) FLAG_DEBUG=1
        ;;
      m) MAILTO=$OPTARG 
        ;;
      v) show_version; usage 
        ;;
      *) usage 
        ;;
    esac
  done
  shift `expr $OPTIND - 1`

  if [ "$MAILTO" == "" ] ; then
    usage
  fi

  if [ "$MAILTO" != "" ] ; then 
    _send_mail
  fi
}

usage () {
	/bin/cat <<END
usage: `basename $0` [-m mail_address] [-v]
  m mail_adderss : send to mail_address
  D              : debug option
  v              : show version
END
	exit 0
}

_send_mail () {
  /bin/cat <<END | $MAIL -s "`/bin/hostname`: `basename $0`" $MAILTO
Hoge
END
}

show_version () {
	echo -e `basename $0` Version: $VERSION
}

main $@

# vim:set ts=2 et sw=2 si:
