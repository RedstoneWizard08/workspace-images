#!/bin/bash

set -e

bash -c 'cat <<- EOF > init.sh
apt-get update
apt-get -y install curl
curl -fsSLo test.sh https://cdn.nosadnile.net/docker-init.sh
history -s "bash /test.sh"
bash
EOF'

bash -c 'cat <<- EOF > init-alpine.sh
apk add curl bash
curl -fsSLo test.sh https://cdn.nosadnile.net/docker-init.sh
PS1="[\\u@\\h \$(pwd)]\\\$ "
echo "PS1=\"[\\\u@\\\h \\\\\\\$(pwd)]\\\$ \"" > \$HOME/.bashrc
bash
EOF'

docker kill docker_testing || true 2>&1 /dev/null
docker rm docker_testing || true 2>&1 /dev/null

if [[ "$1" == "ubuntu" ]]; then
    docker run -it --rm -e DEBIAN_FRONTEND=noninteractive -e TZ=America/Los_Angeles -e NODE_DIRECTORY="/usr/lib/node" \
    -e NODE_VERSION="17.7.1" -e NODE_DOWNLOAD_PREFIX="https://nodejs.org/dist/v" -e NODE_DOWNLOAD_MID="/" \
    -e NODE_PACKAGE_PREFIX="node-v" -e NODE_PACKAGE_MID="-linux-" -e NODE_PACKAGE_SUFFIX=".tar.xz" \
    -e NODE_SHA256SUMS_FILE="SHASUM256.txt" -e NODE_SHA265SUMS_FILE_SHA="SHASUM256.txt.asc" -e NODE_TAR_FLAGS="xvf" \
    -e YARN_VERSION="1.22.17" -e YARN_DOWNLOAD_PREFIX="https://yarnpkg.com/downloads/" -e YARN_DOWNLOAD_MID="/yarn-v" \
    -e YARN_DOWNLOAD_SUFFIX=".tar.gz" -e YARN_SHASUM_EXT="asc" -e YARN_INSTALL_BASE_DIR="/opt" -e YARN_INSTALL_DIR="/opt/yarn" \
    -e YARN_TAR_FLAGS="zxvf" --name docker_testing \
    -v "$(pwd)/init.sh:/init.sh" ubuntu:focal bash /init.sh
    exit 0
elif [[ "$1" == "debian" ]]; then
    docker run -it --rm -e DEBIAN_FRONTEND=noninteractive -e TZ=America/Los_Angeles -e NODE_DIRECTORY="/usr/lib/node" \
    -e NODE_VERSION="17.7.1" -e NODE_DOWNLOAD_PREFIX="https://nodejs.org/dist/v" -e NODE_DOWNLOAD_MID="/" \
    -e NODE_PACKAGE_PREFIX="node-v" -e NODE_PACKAGE_MID="-linux-" -e NODE_PACKAGE_SUFFIX=".tar.xz" \
    -e NODE_SHA256SUMS_FILE="SHASUM256.txt" -e NODE_SHA265SUMS_FILE_SHA="SHASUM256.txt.asc" -e NODE_TAR_FLAGS="xvf" \
    -e YARN_VERSION="1.22.17" -e YARN_DOWNLOAD_PREFIX="https://yarnpkg.com/downloads/" -e YARN_DOWNLOAD_MID="/yarn-v" \
    -e YARN_DOWNLOAD_SUFFIX=".tar.gz" -e YARN_SHASUM_EXT="asc" -e YARN_INSTALL_BASE_DIR="/opt" -e YARN_INSTALL_DIR="/opt/yarn" \
    -e YARN_TAR_FLAGS="zxvf" --name docker_testing \
    -v "$(pwd)/init.sh:/init.sh" debian:buster bash /init.sh
    exit 0
elif [[ "$1" == "debianstretch" ]]; then
    docker run -it --rm -e DEBIAN_FRONTEND=noninteractive -e TZ=America/Los_Angeles -e NODE_DIRECTORY="/usr/lib/node" \
    -e NODE_VERSION="17.7.1" -e NODE_DOWNLOAD_PREFIX="https://nodejs.org/dist/v" -e NODE_DOWNLOAD_MID="/" \
    -e NODE_PACKAGE_PREFIX="node-v" -e NODE_PACKAGE_MID="-linux-" -e NODE_PACKAGE_SUFFIX=".tar.xz" \
    -e NODE_SHA256SUMS_FILE="SHASUM256.txt" -e NODE_SHA265SUMS_FILE_SHA="SHASUM256.txt.asc" -e NODE_TAR_FLAGS="xvf" \
    -e YARN_VERSION="1.22.17" -e YARN_DOWNLOAD_PREFIX="https://yarnpkg.com/downloads/" -e YARN_DOWNLOAD_MID="/yarn-v" \
    -e YARN_DOWNLOAD_SUFFIX=".tar.gz" -e YARN_SHASUM_EXT="asc" -e YARN_INSTALL_BASE_DIR="/opt" -e YARN_INSTALL_DIR="/opt/yarn" \
    -e YARN_TAR_FLAGS="zxvf" --name docker_testing \
    -v "$(pwd)/init.sh:/init.sh" debian:stretch bash /init.sh
    exit 0
elif [[ "$1" == "debianbullseye" ]]; then
    docker run -it --rm -e DEBIAN_FRONTEND=noninteractive -e TZ=America/Los_Angeles -e NODE_DIRECTORY="/usr/lib/node" \
    -e NODE_VERSION="17.7.1" -e NODE_DOWNLOAD_PREFIX="https://nodejs.org/dist/v" -e NODE_DOWNLOAD_MID="/" \
    -e NODE_PACKAGE_PREFIX="node-v" -e NODE_PACKAGE_MID="-linux-" -e NODE_PACKAGE_SUFFIX=".tar.xz" \
    -e NODE_SHA256SUMS_FILE="SHASUM256.txt" -e NODE_SHA265SUMS_FILE_SHA="SHASUM256.txt.asc" -e NODE_TAR_FLAGS="xvf" \
    -e YARN_VERSION="1.22.17" -e YARN_DOWNLOAD_PREFIX="https://yarnpkg.com/downloads/" -e YARN_DOWNLOAD_MID="/yarn-v" \
    -e YARN_DOWNLOAD_SUFFIX=".tar.gz" -e YARN_SHASUM_EXT="asc" -e YARN_INSTALL_BASE_DIR="/opt" -e YARN_INSTALL_DIR="/opt/yarn" \
    -e YARN_TAR_FLAGS="zxvf" --name docker_testing \
    -v "$(pwd)/init.sh:/init.sh" debian:bullseye bash /init.sh
    exit 0
elif [[ "$1" == "alpine" ]]; then
    docker run -it --rm -e DEBIAN_FRONTEND=noninteractive -e TZ=America/Los_Angeles -e NODE_DIRECTORY="/usr/lib/node" \
    -e NODE_VERSION="17.7.1" -e NODE_DOWNLOAD_PREFIX="https://nodejs.org/dist/v" -e NODE_DOWNLOAD_MID="/" \
    -e NODE_PACKAGE_PREFIX="node-v" -e NODE_PACKAGE_MID="-linux-" -e NODE_PACKAGE_SUFFIX=".tar.xz" \
    -e NODE_SHA256SUMS_FILE="SHASUM256.txt" -e NODE_SHA265SUMS_FILE_SHA="SHASUM256.txt.asc" -e NODE_TAR_FLAGS="xvf" \
    -e YARN_VERSION="1.22.17" -e YARN_DOWNLOAD_PREFIX="https://yarnpkg.com/downloads/" -e YARN_DOWNLOAD_MID="/yarn-v" \
    -e YARN_DOWNLOAD_SUFFIX=".tar.gz" -e YARN_SHASUM_EXT="asc" -e YARN_INSTALL_BASE_DIR="/opt" -e YARN_INSTALL_DIR="/opt/yarn" \
    -e YARN_TAR_FLAGS="zxvf" --name docker_testing \
    -v "$(pwd)/init-alpine.sh:/init.sh" alpine:3 ash /init.sh
    exit 0
elif [[ "$1" == "alpine3.15" ]]; then
    docker run -it --rm -e DEBIAN_FRONTEND=noninteractive -e TZ=America/Los_Angeles -e NODE_DIRECTORY="/usr/lib/node" \
    -e NODE_VERSION="17.7.1" -e NODE_DOWNLOAD_PREFIX="https://nodejs.org/dist/v" -e NODE_DOWNLOAD_MID="/" \
    -e NODE_PACKAGE_PREFIX="node-v" -e NODE_PACKAGE_MID="-linux-" -e NODE_PACKAGE_SUFFIX=".tar.xz" \
    -e NODE_SHA256SUMS_FILE="SHASUM256.txt" -e NODE_SHA265SUMS_FILE_SHA="SHASUM256.txt.asc" -e NODE_TAR_FLAGS="xvf" \
    -e YARN_VERSION="1.22.17" -e YARN_DOWNLOAD_PREFIX="https://yarnpkg.com/downloads/" -e YARN_DOWNLOAD_MID="/yarn-v" \
    -e YARN_DOWNLOAD_SUFFIX=".tar.gz" -e YARN_SHASUM_EXT="asc" -e YARN_INSTALL_BASE_DIR="/opt" -e YARN_INSTALL_DIR="/opt/yarn" \
    -e YARN_TAR_FLAGS="zxvf" --name docker_testing \
    -v "$(pwd)/init-alpine.sh:/init.sh" alpine:3.15 ash /init.sh
    exit 0
elif [[ "$1" == "alpine3.14" ]]; then
    docker run -it --rm -e DEBIAN_FRONTEND=noninteractive -e TZ=America/Los_Angeles -e NODE_DIRECTORY="/usr/lib/node" \
    -e NODE_VERSION="17.7.1" -e NODE_DOWNLOAD_PREFIX="https://nodejs.org/dist/v" -e NODE_DOWNLOAD_MID="/" \
    -e NODE_PACKAGE_PREFIX="node-v" -e NODE_PACKAGE_MID="-linux-" -e NODE_PACKAGE_SUFFIX=".tar.xz" \
    -e NODE_SHA256SUMS_FILE="SHASUM256.txt" -e NODE_SHA265SUMS_FILE_SHA="SHASUM256.txt.asc" -e NODE_TAR_FLAGS="xvf" \
    -e YARN_VERSION="1.22.17" -e YARN_DOWNLOAD_PREFIX="https://yarnpkg.com/downloads/" -e YARN_DOWNLOAD_MID="/yarn-v" \
    -e YARN_DOWNLOAD_SUFFIX=".tar.gz" -e YARN_SHASUM_EXT="asc" -e YARN_INSTALL_BASE_DIR="/opt" -e YARN_INSTALL_DIR="/opt/yarn" \
    -e YARN_TAR_FLAGS="zxvf" --name docker_testing \
    -v "$(pwd)/init-alpine.sh:/init.sh" alpine:3.14 ash /init.sh
    exit 0
else
    echo "No OS specified. Available OSes: ubuntu, debian, debianstretch, debianbullseye, alpine, alpine3.15, alpine3.14."
fi