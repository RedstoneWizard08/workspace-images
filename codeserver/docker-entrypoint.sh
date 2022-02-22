#!/bin/bash

source $HOME/.bashrc
nvm use 14
cd /ide
yarn install

export CODE_SERVER_VERSION="4.0.2"
export ARCH=`dpkg --print-architecture`

case $ARCH in
    "armhf") export ARCH="armv7l" ;;
    *) esac

cd /workspace

if [[ ! -z "$1" ]]; then
    echo "Cloning repo: $1."
    git clone $1 /workspace || true
else
    echo "Not cloning repo."
fi

/ide/code-server-$CODE_SERVER_VERSION-linux-$ARCH/bin/code-server --auth none --bind-addr 0.0.0.0 --port 8088