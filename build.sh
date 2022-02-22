#!/bin/bash

#
#   Note: This script does support amd64.
#

set -e

cd base
docker buildx build --platform linux/arm64,linux/amd64 -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/base --push .

cd ../openvscode
docker buildx build --platform linux/arm64,linux/amd64 -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/openvscode --push .

cd ../codeserver
docker buildx build --platform linux/arm64 -t reg.git.nosadnile.net:443/redstonewizard08/workspace-images/codeserver --push .