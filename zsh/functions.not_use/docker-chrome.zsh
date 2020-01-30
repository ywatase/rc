xquartz_if_not_running() {
	v_nolisten_tcp=$(defaults read org.macosforge.xquartz.X11 nolisten_tcp)
	v_xquartz_app=$(defaults read org.macosforge.xquartz.X11 app_to_run)

	if [[ $v_nolisten_tcp == "1" ]]; then
		defaults write org.macosforge.xquartz.X11 nolisten_tcp 0
	fi

	if [[ $v_xquartz_app != "/usr/bin/true" ]]; then
		defaults write org.macosforge.xquartz.X11 app_to_run /usr/bin/true
	fi

	netstat -an | grep 6000 &> /dev/null || open -a XQuartz
	while ! netstat -an \| grep 6000 &> /dev/null; do
		sleep 2
	done
#	export DISPLAY=:0
}

docker-run-x () {
  xquartz_if_not_running
  xhost + 127.0.0.1
  docker run -e DISPLAY=docker.for.mac.localhost:0 "$@"
}

docker-chrome () {
  docker-run-x --rm  --privileged "$@" --name jesschrome jess/chrome
}
docker-chrome-ja () {
  docker-run-x --rm  --privileged "$@" --name ywatachrome ywatase/chrome_ja
}

docker-chrome-ja-with-ro-userdata () {
  local DATA_CONTAINER_ID=$(docker run -dit -v /data --name data ubuntu:14.04 /bin/bash)
  docker run --rm --volumes-from data -v "$HOME/Library/Application Support/Google/Chrome/:/userdata:ro" ubuntu:14.04 cp -r /userdata/Default /data
  docker-run-x --rm  --privileged --volumes-from data "$@" --name ywatachrome ywatase/chrome_ja
  docker kill ${DATA_CONTAINER_ID}
}

docker-chrome-ja-with-full () {
  docker-run-x --rm  --privileged -v $HOME/Downloads:/root/Downloads -v "$HOME/Library/Application Support/Google/Chrome/:/data:ro" "$@" --name ywatachrome ywatase/chrome_ja
}

