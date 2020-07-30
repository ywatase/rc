#!/bin/sh
set -eu
DOCKER_PLUGIN_DIR=${DOCKER_PLUGIN_DIR:-/usr/local/lib/docker/cli-plugins}

install () {
  curl -LO https://github.com/docker/ecs-plugin/releases/latest/download/docker-ecs-linux-amd64
  chmod +x docker-ecs-linux-amd64
  mkdir -p $DOCKER_PLUGIN_DIR
  mv docker-ecs-linux-amd64 $DOCKER_PLUGIN_DIR/docker-ecs
}

uninstall () {
  rm $DOCKER_PLUGIN_DIR/docker-ecs
  rmdir $DOCKER_PLUGIN_DIR || true
}

enable () {
  jq '. + {"experimental": "enabled"}' ~/.docker/config.json > ~/.docker/config.enabled.json
  if ! [ -L ~/.docker/config.json ] ; then
    mv ~/.docker/config.json ~/.docker/config.json.orig
  fi
  ln -sf config.enabled.json ~/.docker/config.json
}

disable () {
  jq '. + {"experimental": "disabled"}' ~/.docker/config.json > ~/.docker/config.disabled.json
  if ! [ -L ~/.docker/config.json ] ; then
    mv ~/.docker/config.json ~/.docker/config.json.orig
  fi
  ln -sf config.disabled.json ~/.docker/config.json
}

verify () {
  docker ecs version || true
  cat <<EOS
# docker config check (jq -r '.experimental' ~/.docker/config.json)
experimental: $(jq -r '.experimental' ~/.docker/config.json)
EOS
}

commands () {
  cat <<EOS
install
uninstall
enable
disable
verify
commands
help
EOS
}

usage () {
  cat <<EOS
$(basename $0) command

command:
    install
    uninstall
    enable
    disable
    commands
    verify
EOS
}

set +u
cmd=$1
set -u


case $cmd in
    install|enable|disable|uninstall|verify|commands)
        $cmd
        ;;
    *)
        usage
        ;;
esac

# vim: set et ts=2 sts=2 sw=2 :
