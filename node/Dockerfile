ARG OS="ubuntu"
ARG OS_VERSION="focal"

FROM ${OS}:${OS_VERSION}

ARG SET_NODE_VERSION="17.7.1"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

ENV NODE_DIRECTORY="/usr/lib/node"
ENV NODE_VERSION="${SET_NODE_VERSION}"
ENV NODE_DOWNLOAD_PREFIX="https://nodejs.org/dist/v"
ENV NODE_DOWNLOAD_MID="/"
ENV NODE_PACKAGE_PREFIX="node-v"
ENV NODE_PACKAGE_MID="-linux-"
ENV NODE_PACKAGE_SUFFIX=".tar.xz"
ENV NODE_SHA256SUMS_FILE="SHASUM256.txt"
ENV NODE_SHA265SUMS_FILE_SHA="SHASUM256.txt.asc"
ENV NODE_TAR_FLAGS="xvf"
# zxvf for tar.gz files, zxf for non-verbose tar.gz, xf for non-verbose tar.xz

ENV YARN_VERSION="1.22.17"
ENV YARN_DOWNLOAD_PREFIX="https://yarnpkg.com/downloads/"
ENV YARN_DOWNLOAD_MID="/yarn-v"
ENV YARN_DOWNLOAD_SUFFIX=".tar.gz"
ENV YARN_SHASUM_EXT="asc"
ENV YARN_INSTALL_BASE_DIR="/opt"
ENV YARN_INSTALL_DIR="/opt/yarn"
ENV YARN_TAR_FLAGS="zxvf"
# zxvf for tar.gz files, zxf for non-verbose tar.gz, xf for non-verbose tar.xz

ADD docker-init.sh /init.sh

RUN sh /init.sh && \
    rm /init.sh

CMD [ "/usr/local/bin/node" ]