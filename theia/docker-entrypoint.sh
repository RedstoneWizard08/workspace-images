#!/bin/sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
source $HOME/.bashrc

cd /workspace

if [[ ! -z "$1" ]]; then
    echo "Cloning repo: $1."
    git clone $1 /workspace || true
else
    echo "Not cloning repo."
fi

nvm exec 12 node /ide/src-gen/backend/main.js /workspace --hostname 0.0.0.0 --port 8088