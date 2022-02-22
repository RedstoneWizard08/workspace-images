FROM reg.git.nosadnile.net:443/redstonewizard08/workspace-images/base:devel

# OpenVSCode
ENV CODE_SERVER_VERSION="4.0.2"
RUN export ARCH=`dpkg --print-architecture` && \
    case $ARCH in \
    "armhf") export ARCH="armv7l" ;; \
    *) esac && \
    curl -fsSLO "https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-linux-${ARCH}.tar.gz" && \
    tar -C "/ide" -zxvf "code-server-${CODE_SERVER_VERSION}-linux-${ARCH}.tar.gz" && \
    rm "code-server-${CODE_SERVER_VERSION}-linux-${ARCH}.tar.gz"

RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    source $HOME/.bashrc && \
    nvm install 14 && \
    nvm install 16 && \
    nvm use 16 && \
    source $HOME/.bashrc && \
    nvm exec 14 npm install --global npm@latest yarn@latest && \
    nvm exec 14 corepack enable && \
    export ARCH=`dpkg --print-architecture` && \
    case $ARCH in \
    "armhf") export ARCH="armv7l" ;; \
    *) esac && \
    cd /ide/code-server-$CODE_SERVER_VERSION-linux-$ARCH && \
    nvm exec 14 yarn install

# Entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN sudo chmod a+rx /docker-entrypoint.sh
ENTRYPOINT [ "/bin/bash", "/docker-entrypoint.sh" ]