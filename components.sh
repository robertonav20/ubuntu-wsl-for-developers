#!/bin/bash

## REGION Functions
##

# Define version
JAVA_VERSION=openjdk-17-jdk
NVM_VERSION=v0.39.7
NODE_JS_VERSION=20
MAVEN=maven

# Exit immediately if a command exits with a non-zero status
set -e

apt install git zsh -y

# Install NodeJS (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
nvm install $NODE_JS_VERSION

# Install Python 3
apt install python3 -y
python -m pip3 install --upgrade pip

# Install Podman and Podman Compose
apt install podman -y
pip3 install podman-compose

# Install Java 17
apt install $JAVA_VERSION -y

# Install Java 17
apt install $MAVEN -y

echo "All components installed successfully."
