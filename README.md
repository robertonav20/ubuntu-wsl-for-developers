## Import image as wsl

2. Running image

```bash
docker run -t ubuntu-wsl:1.1.0 bash
```

3. Export container as tar file

```bash
docker export --output ubuntu-wsl-1.1.0.tar $(docker ps -a --format "{{.Names}}")
```

4. Import tar file

```bash
wsl --import "Ubuntu-WSL-1.1.0" C:\\Users\\rob\\Ubuntu-WSL-1.1.0 .\\ubuntu-wsl-1.1.0.tar
```

5. Install tar file

```bash
wsl install -d Ubuntu-WSL-1.1.0
```

NOTE: all steps can be done with `docker Desktop`
<!--  -->
# Build image or pull image

To obtain the image there are 2 ways

1. `Build image`

```bash
docker build --file Dockerfile . --tag ubuntu-wsl:1.1.0
```

NOTE: is possible build image starting from own `Dockerfile`

2. `Pull image`

```bash
docker pull ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.1.0
```

## Publish image to github registry

1. Login Github Registry

```bash
echo "YOUR_PASSWORD" | docker login ghcr.io --username YOUR_USERNAME --password-stdin
```

2. Push Github Registry

```bash
docker tag ubuntu-wsl:1.1.0 ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.1.0
docker push ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.1.0
```

1. Login Github Registry

```bash
echo "YOUR_PASSWORD" | docker login docker.io --username YOUR_USERNAME --password-stdin
```

2. Push Docker Registry

```bash
docker tag ubuntu-wsl:1.1.0 docker.io/robnav24241/customized-wsl-image:1.1.0
docker push docker.io/robnav24241/customized-wsl-image:1.1.0
```
