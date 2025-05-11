#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

BUILD_VERSION=1.0.0

echo "Build Image ubuntu-wsl:$BUILD_VERSION"
docker build --tag ubuntu-wsl:$BUILD_VERSION --file Dockerfile .

echo "Publish Image ubuntu-wsl:$BUILD_VERSION"
docker tag ubuntu-wsl:$BUILD_VERSION ghcr.io/robertonav20/ubuntu-wsl-for-developers/ubuntu-wsl:$BUILD_VERSION
docker push ghcr.io/robertonav20/ubuntu-wsl-for-developers/ubuntu-wsl:$BUILD_VERSION

echo "Exporting Container ubuntu-wsl:$BUILD_VERSION as archive"
docker run --name ubuntu-wsl -it ubuntu-wsl:$BUILD_VERSION bash -C exit
docker export --output ubuntu-wsl-$BUILD_VERSION.tar ubuntu-wsl
docker rm ubuntu-wsl || true
gzip -f ubuntu-wsl-$BUILD_VERSION.tar

echo "Creating Tag and Release"
git tag v$BUILD_VERSION
git push origin v$BUILD_VERSION --tags
gh release create v$BUILD_VERSION ubuntu-wsl-$BUILD_VERSION.tar.gz --title "V$BUILD_VERSION"