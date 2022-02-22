#!/bin/bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
source $HOME/.bashrc
cd /ide
#nvm exec 14 yarn install

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