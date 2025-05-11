# Ubuntu WSL for Developers :computer::zap:

## Import image as wsl

1. Running image

   ```bash
   docker run --name ubuntu-wsl-1.7.0 -it ubuntu-wsl:1.7.0 bash -C exit
   ```

2. Export container as tar file

   ```bash
   docker export --output ubuntu-wsl-1.7.0.tar ubuntu-wsl-1.7.0
   ```

3. Move tar to windows file system

   ```bash
   mkdir -p /mnt/c/Users/$USER/Ubuntu-WSL-1.7.0 && mv ubuntu-wsl-1.7.0.tar /mnt/c/Users/$USER/
   ```

4. Import tar file

   ```bash
   wsl --import "Ubuntu-WSL-1.7.0" C:\\Users\\rob\\Ubuntu-WSL-1.7.0 .\\ubuntu-wsl-1.7.0.tar
   ```

5. Install tar file

   ```bash
   wsl install -d Ubuntu-WSL-1.7.0
   ```

NOTE: all steps can be done with `podman Desktop`

<!--  -->

## Build image or pull image

To obtain the image there are 2 ways

1. `Build image`

   ```bash
   docker build --tag ubuntu-wsl:1.7.0 --file Dockerfile .
   ```

2. `Pull image`

   ```bash
   docker pull ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.7.0
   ```

## Publish image to github registry

1. Login Github Registry

   ```bash
   echo "YOUR_PASSWORD" | docker login ghcr.io --username YOUR_USERNAME --password-stdin
   ```

2. Push Github Registry

   ```bash
   docker tag ubuntu-wsl:1.7.0 ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.7.0
   docker push ghcr.io/robertonav20/customized-wsl-image/ubuntu-wsl:1.7.0
   ```

3. Login Docker Registry

   ```bash
   echo "YOUR_PASSWORD" | docker login docker.io --username YOUR_USERNAME --password-stdin
   ```

4. Push Docker Registry

   ```bash
   docker tag ubuntu-wsl:1.7.0 docker.io/robnav24241/customized-wsl-image:1.7.0
   docker push docker.io/robnav24241/customized-wsl-image:1.7.0
   ```

## Useful WSL Command

- Show All WSL

  ```bash
      wsl --list --all
  ```

- Import WSL

  ```bash
      wsl --import "Ubuntu-WSL-1.7.0" C:\\Users\\rob\\Ubuntu-WSL-1.7.0 .\\ubuntu-wsl-1.7.0.tar
  ```

- Install WSL

  ```bash
      wsl install -d Ubuntu-WSL-1.7.0
  ```

- Unregister WSL

  ```bash
      wsl --unregister Ubuntu-WSL-1.7.0
  ```

- Shutdown WSL

  ```bash
      wsl --shutdown
  ```

- Mount Windows Path to WSL

  ```bash
      sudo mkdir -p /mnt/share && sudo mount -t drvfs 'YOUR_WINDOWS_PATH' /mnt/share
  ```
