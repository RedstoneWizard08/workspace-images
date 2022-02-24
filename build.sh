#!/bin/bash

#
#   Note: This script does support amd64, however there are some troubles with qemu.
#

set -e

if [[ ! "$CI" == true ]]; then
    TAG="local_devel"
    ARGS="--build-arg TAG=local_devel"
else
    TAG="devel"
    ARGS="--build-arg TAG=devel"

    CI_MULTI_BASE_TAG="-t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/base:$CI_COMMIT_SHORT_SHA"
    CI_MULTI_OPENVSCODE_TAG="-t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/openvscode:$CI_COMMIT_SHORT_SHA"
    CI_MULTI_CODESERVER_TAG="-t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/codeserver:$CI_COMMIT_SHORT_SHA"
    CI_MULTI_THEIA_TAG="-t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/theia:$CI_COMMIT_SHORT_SHA"

    CI_MULTI_HEADLESS_BASE_TAG="-t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/headless-base:$CI_COMMIT_SHORT_SHA"
fi

#
#   Full images with IDE embedded in the container.
#

# Base Image
cd base
docker buildx build --platform linux/amd64 $ARGS -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/base:$TAG $CI_MULTI_BASE_TAG --push .

# OpenVSCode Image
cd ../openvscode
docker buildx build --platform linux/amd64 $ARGS -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/openvscode:$TAG $CI_MULTI_OPENVSCODE_TAG --push .

# Code-Server Image
cd ../codeserver
docker buildx build --platform linux/amd64 $ARGS -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/codeserver:$TAG $CI_MULTI_CODESERVER_TAG --push .

# Theia Image
cd ../theia
docker buildx build --platform linux/amd64 $ARGS -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/theia:$TAG $CI_MULTI_THEIA_TAG --push .

#
#   Headless images without an IDE embedded in the container.
#

# Theia Image
cd ../headless-base
docker buildx build --platform linux/amd64 $ARGS -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/headless-base:$TAG $CI_MULTI_HEADLESS_BASE_TAG --push .