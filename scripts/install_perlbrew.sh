#!/bin/sh

# skel.sh
#   Purpose: skelton of shell script
#
#   Auther: Y.Watawe <watase.yusuke@adways.net>
#   Create Date: 2008/03/27
#   Last Modified: 2010/06/04.

VERSION=0.1
PERL_VERSION=5.10.1

# initialize

function usage () {
	/bin/cat <<END
usage: `basename $0` [-p version] [-v]
  p version      : install perl version (default: $PERL_VERSION)
  v              : show version
END
	exit 0
}

function show_version () {
	echo -e `basename $0` Version: $VERSION
}

while getopts 'p:vh' opt
do
case $opt in
  p) PERL_VERSION=$OPTARG ;;
  v) show_version; usage ;;
  *) usage ;;
esac
done

if [ `which wget` ] ; then
	wget http://xrl.us/perlbrew
elif [ `which curl` ] ; then
	curl -LO http://xrl.us/perlbrew
fi
chmod +x perlbrew
./perlbrew install
rm ./perlbrew
$HOME/perl5/perlbrew/bin/perlbrew init
$HOME/perl5/perlbrew/bin/perlbrew install perl-$PERL_VERSION
$HOME/perl5/perlbrew/bin/perlbrew perlbrew switch  perl-$PERL_VERSION
