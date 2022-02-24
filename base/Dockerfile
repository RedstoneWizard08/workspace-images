# Base OS
FROM ubuntu:20.04

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
    apt-utils git tzdata xz-utils

# Bash
SHELL [ "/bin/bash", "-c" ]

# IDE Folder
RUN mkdir /ide /workspace

# Workspace user
RUN useradd -l -u 33333 -G sudo -md /home/workspace -s /bin/bash -p workspace workspace && \
    passwd -d workspace && \
    echo "workspace ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod -R a+rwx /ide /workspace
USER workspace

# Home
ENV HOME=/home/workspace
WORKDIR /workspace

# Custom bash prompt
RUN echo "export PS_=\$PS1" >> $HOME/.bashrc && \
    echo "export PS1=\"\\[\\e]0;\\u@\\h: \\w\\a\\]\\[\\033[;32m\\]┌──\${debian_chroot:+($debian_chroot)──}\${VIRTUAL_ENV:+(\\[\\033[0;1m\\]\$(basename \$VIRTUAL_ENV)\\[\\033[;32m\\])}(\\[\\033[1;34m\\]\\u@\${prompt_symbol}\\h\\[\\033[;32m\\])-[\\[\\033[0;1m\\]\\w\\[\\033[;32m\\]]\\n\\[\\033[;32m\\]└─\\[\\033[1;34m\\]\\\$\\[\\033[0m\\] \"" >> $HOME/.bashrc

# Node.js
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    source ~/.bashrc && \
    nvm install 16 && \
    nvm use 16 && \
    source ~/.bashrc && \
    npm install --global npm@latest yarn@latest && \
    corepack enable

# Git LFS
RUN curl -fsSL https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    sudo apt-get -y install git-lfs && \
    git lfs install --system

# Clean
RUN sudo apt-get clean && \
    sudo apt-get autoremove -y && \
    sudo rm -rf /var/cache/apt/* && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo rm -rf /tmp/*