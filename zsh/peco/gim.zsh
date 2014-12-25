# vim:set et ts=2 sts=2 sw=2:
gim () {
  local selected_file=$(git ls-files | peco)
  if [ -n "$selected_file" ] ; then
    vim $selected_file
  fi
}
