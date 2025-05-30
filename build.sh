#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Build Image ubuntu-wsl:$BUILD_VERSION"
docker build --tag ubuntu-wsl:$BUILD_VERSION --file Dockerfile .

echo "Publish Image ubuntu-wsl:$BUILD_VERSION"
docker tag ubuntu-wsl:$BUILD_VERSION ghcr.io/robertonav20/ubuntu-wsl-for-developers/ubuntu-wsl:$BUILD_VERSION
docker push ghcr.io/robertonav20/ubuntu-wsl-for-developers/ubuntu-wsl:$BUILD_VERSION

echo "Exporting Container ubuntu-wsl:$BUILD_VERSION as archive"
docker run --name ubuntu-wsl ubuntu-wsl:$BUILD_VERSION
docker stop ubuntu-wsl
docker export ubuntu-wsl > ubuntu-wsl-$BUILD_VERSION.tar
gzip -f ubuntu-wsl-$BUILD_VERSION.tar

#echo "Creating Tag and Release"
#git tag v$BUILD_VERSION
#git push origin v$BUILD_VERSION --tags
#gh release create v$BUILD_VERSION ubuntu-wsl-$BUILD_VERSION.tar.gz --title "v$BUILD_VERSION"
