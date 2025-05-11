#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define installation directory
INSTALL_DIR="/usr/local/bin"

# Update packages repositories
sudo apt-get update

# Define version
GO_VERSION=go1.24.2.linux-amd64.tar.gz
JAVA_VERSION=openjdk-17-jdk
NVM_VERSION=v0.40.3
NODE_VERSION=20
PYTHON_VERSION=python3-pip
MAVEN=maven

# Install NodeJS (Node Version Manager)
echo "Installing $NODE_JS_VERSION"
export NVM_DIR=/root/.nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
source $NVM_DIR/nvm.sh
nvm install $NODE_VERSION

# Install Python 3
echo "Installing $PYTHON_VERSION"
apt install -y $PYTHON_VERSION

# Install Java 17
echo "Installing $JAVA_VERSION"
apt install -y $JAVA_VERSION

# Install MAVEN
echo "Installing $MAVEN"
apt install -y $MAVEN

# Install Go 1.24
echo "Installing $GO_VERSION"
curl -sL https://go.dev/dl/$GO_VERSION | tar zxf - -C /usr/share/
ln -s /usr/share/go/bin/go /usr/local/bin/go
ln -s /usr/share/go/bin/gofmt /usr/local/bin/gofmt

# Install Docker and Docker Compose
echo "Installing docker and docker-compose"

# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker
if [ $(getent group docker) ]; then
    echo "Docker group already exists."
else
    sudo groupadd docker
fi
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo "All components installed successfully."
exit 0
