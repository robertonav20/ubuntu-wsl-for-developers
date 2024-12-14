echo "Build Image ubuntu-wsl:1.1.0"

docker build --file Dockerfile . --tag ubuntu-wsl:1.1.0

echo "Publish Image ubuntu-wsl:1.1.0"

docker tag ubuntu-wsl:1.1.0 ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.1.0
docker push ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.1.0