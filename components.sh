#!/bin/bash

## REGION Functions
##

# Define version
JAVA_VERSION=openjdk-17-jdk
NODE_JS_VERSION=nodejs
PYTHON_VERSION=python3-pip
MAVEN=maven

# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing git and zsh"
apt install git zsh -y

# Install NodeJS (Node Version Manager)
echo "Installing $NODE_JS_VERSION"
apt install $NODE_JS_VERSION -y

# Install Python 3
echo "Installing $PYTHON_VERSION"
apt install $PYTHON_VERSION -y

# Install Docker and Docker Compose
echo "Installing docker and docker-compose"

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker
sudo groupadd docker
sudo usermod -aG docker $USER_NAME
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo tee -a /etc/wsl.conf << EOF
[boot]
systemd=true
EOF

# Install Java 17
echo "Installing $JAVA_VERSION"
apt install $JAVA_VERSION -y

# Install Java 17
echo "Installing $MAVEN"
apt install $MAVEN -y

echo "All components installed successfully."
