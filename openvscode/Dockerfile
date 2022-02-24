# Base OS
ARG TAG=devel
FROM reg.git.nosadnile.net:443/redstonewizard08/workspace-images/base:${TAG}

# OpenVSCode
ENV OPENVSCODE_VERSION="1.64.2"
RUN export ARCH=`dpkg --print-architecture` && \
    case $ARCH in \
    "amd64") export ARCH="x64" ;; \
    *) esac && \
    curl -fsSLO "https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v${OPENVSCODE_VERSION}/openvscode-server-v${OPENVSCODE_VERSION}-linux-${ARCH}.tar.gz" && \
    tar -C "/ide" -zxvf "openvscode-server-v${OPENVSCODE_VERSION}-linux-${ARCH}.tar.gz" && \
    rm "openvscode-server-v${OPENVSCODE_VERSION}-linux-${ARCH}.tar.gz"

# Entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN sudo chmod a+rx /docker-entrypoint.sh
ENTRYPOINT [ "/bin/bash", "/docker-entrypoint.sh" ]