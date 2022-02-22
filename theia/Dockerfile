# Builder
FROM ubuntu:20.04 as builder

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Pacific
ENV LC_ALL=C
ENV LANG=en_US.UTF-8

# Packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
    curl wget sudo bash apt \
    apt-utils git tzdata \
    libsecret-1-dev gnupg \
    lsb-release make cmake \
    g++ gcc build-essential \
    xz-utils gpg python2 python3 && \
    mkdir /ide

# Workdir
WORKDIR /ide

# Node.js install
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | sudo -E bash - && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs && \
    npm install --global npm@latest \
    corepack@latest && \
    corepack enable

# Add package.json
ADD package.json /ide/package.json

# Install
RUN yarn install --cache-folder ./ycache && \
    rm -rf ./ycache && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && yarn theia download:plugins

# Clean
RUN apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# IDE
FROM reg.git.nosadnile.net:443/redstonewizard08/workspace-images/base:devel

# Theia
COPY --from=builder /ide /ide

# Entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN sudo apt-get -y install libsecret-1-dev

RUN sudo chmod a+rx /docker-entrypoint.sh && \
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    source $HOME/.bashrc && \
    nvm install 12 && \
    nvm install 16 && \
    nvm use 16 && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    source $HOME/.bashrc && \
    npm install --global npm@latest corepack@latest && \
    corepack enable

# Clean
RUN sudo apt-get clean && \
    sudo apt-get autoremove -y && \
    sudo rm -rf /var/cache/apt/* && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo rm -rf /tmp/*

ENV SHELL=/bin/bash
ENV THEIA_DEFAULT_PLUGINS=local-dir:/ide/plugins

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENTRYPOINT [ "/bin/bash", "/docker-entrypoint.sh" ]