#!/usr/bin/zsh

if [ ! -n "$WSL_DISTRO_NAME" ];
then
  echo "error: Not WSL environment"
  exit 0
fi

sudo ip addr show eth0 | grep -s "172.18.18.128/24" > /dev/null
if [ $? = 1 ]; then
  sudo ip addr add 172.18.18.128/24 broadcast 172.18.18.255 dev eth0 label eth0:1
fi
