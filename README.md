## Build image or pull image

To obtain the image there are 2 ways
1. `Build image`
```bash
podman build --file Dockerfile . --tag ubuntu-wsl:1.0.0 --squash
```
NOTE: is possible build image starting from own `Dockerfile`

2. `Pull image`
```bash
podman pull ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.0.0
```

## Import as wsl

2. Running image
```bash
podman run -t ubuntu-wsl:1.0.0 bash --squash
```

3. Export container as tar file
```bash
podman export --output ubuntu-wsl-1.0.0.tar $(podman ps -a --format "{{.Names}}")
```

4. Import tar file
```bash
wsl --import "Ubuntu-WSL-1.0.0" C:\\Users\\rob\\Ubuntu-WSL-1.0.0 .\\ubuntu-wsl-1.0.0.tar
```

5. Import tar file
```bash
wsl -d Ubuntu-WSL-1.0.0
```

## Publish image to github registry
1. Login
```bash
echo "YOUR_PASSWORD" | podman login ghcr.io --username YOUR_USERNAME --password-stdin
```
2. Push
```bash
podman tag ubuntu-wsl:1.0.0 ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.0.0
podman push ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.0.0
```

