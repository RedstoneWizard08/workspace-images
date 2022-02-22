#!/bin/bash

#
#   Note: This script does support amd64, however there are some troubles with qemu.
#

set -e

cd base
docker buildx build --platform linux/arm64 -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/base:$CI_COMMIT_SHORT_SHA -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/base:devel --push .

cd ../openvscode
docker buildx build --platform linux/arm64 -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/openvscode:$CI_COMMIT_SHORT_SHA -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/openvscode:devel --push .

cd ../codeserver
docker buildx build --platform linux/arm64 -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/codeserver:$CI_COMMIT_SHORT_SHA -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/codeserver:devel --push .

cd ../theia
docker buildx build --platform linux/arm64 -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/theia:$CI_COMMIT_SHORT_SHA -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/theia:devel --push .
