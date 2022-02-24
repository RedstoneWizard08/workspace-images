# Base OS
ARG TAG=devel
FROM reg.git.nosadnile.net:443/redstonewizard08/workspace-images/base:${TAG}

# Root user
USER root

# Packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
    openssh-server wget \
    curl bash libc6 \
    libstdc++6 python2-minimal \
    ca-certificates tar

# Clean
RUN sudo apt-get clean && \
    sudo apt-get autoremove -y && \
    sudo rm -rf /var/cache/apt/* && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo rm -rf /tmp/*

# Workspace user
USER workspace

# Command
ENTRYPOINT [ "/bin/bash" ]