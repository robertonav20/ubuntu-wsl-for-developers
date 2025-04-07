echo "Build Image ubuntu-wsl:1.5.0"
docker build --tag ubuntu-wsl:1.5.0 --file Dockerfile .

echo "Publish Image ubuntu-wsl:1.5.0"
docker tag ubuntu-wsl:1.5.0 ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.5.0
docker push ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.5.0

echo "Exporting Container ubuntu-wsl:1.5.0 as archive"
docker stop ubuntu-wsl || true && docker rm ubuntu-wsl || true
docker run --name ubuntu-wsl -it ubuntu-wsl:1.5.0 bash -C exit
docker export --output ubuntu-wsl-1.5.0.tar ubuntu-wsl
