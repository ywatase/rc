#!/bin/sh

VERSION=`curl https://github.com/adobe-fonts/source-han-code-jp/releases/latest 2>/dev/null | perl -ne 'm{="[^"]*/tag/([^"]+)">} and  print $1;'`
if ! [ -e $VERSION.tar.gz ] ; then
  curl -LO https://github.com/adobe-fonts/source-han-code-jp/archive/$VERSION.tar.gz
fi
tar xzf $VERSION.tar.gz
cd $(tar tzf $VERSION.tar.gz | head -n 1)
open OTC/SourceHanCodeJP.ttc
