#!/bin/bash

#
#   Note: This script does support amd64.
#

set -e

cd base
docker buildx build --platform linux/arm64 -t reg.nosadnile.net/workspace-images/base --push .

cd ../openvscode
docker buildx build --platform linux/arm64 -t reg.nosadnile.net/workspace-images/openvscode --push .

cd ../codeserver
docker buildx build --platform linux/arm64 -t reg.nosadnile.net/workspace-images/codeserver --push .