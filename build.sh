echo "Build Image ubuntu-wsl:1.2.0"

docker build --tag ubuntu-wsl:1.2.0 --file Dockerfile .

echo "Publish Image ubuntu-wsl:1.2.0"

docker tag ubuntu-wsl:1.2.0 ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.2.0
docker push ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.2.0