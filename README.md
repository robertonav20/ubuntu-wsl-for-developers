
1. Build image
```bash
podman build --file Dockerfile . --tag ubuntu-wsl:1.0.0 --squash
```

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