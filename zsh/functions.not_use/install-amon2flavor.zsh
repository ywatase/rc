install-amon2flavor () {
  local path_rcfile
  local cwd
  cwd=`pwd`
  path_rcfile=$(dirname  $(perl -le 'use Cwd; print Cwd::abs_path($ARGV[0])' ~/.vim))
  cd $path_rcfile/perl
  tar czf Amon2-Setup-Flavor-Teng.tar.gz Amon2-Setup-Flavor-Teng
  cpanm ./Amon2-Setup-Flavor-Teng.tar.gz
  rm Amon2-Setup-Flavor-Teng.tar.gz
  cd $cwd
}
