
```bash
podman build --file Dockerfile . --tag ubuntu-wsl:1.0.0
```

```bash
podman run -t ubuntu-wsl:1.0.0 bash --squash
```
