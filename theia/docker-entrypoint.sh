#!/bin/sh

export OPENVSCODE_VERSION="1.64.2"
export ARCH=`dpkg --print-architecture`

case $ARCH in
    "amd64") export ARCH="x64" ;;
    *) esac

cd /workspace

if [[ ! -z "$1" ]]; then
    echo "Cloning repo: $1."
    git clone $1 /workspace || true
else
    echo "Not cloning repo."
fi

/ide/openvscode-server-v$OPENVSCODE_VERSION-linux-$ARCH/bin/openvscode-server --without-connection-token --host 0.0.0.0 --port 8088