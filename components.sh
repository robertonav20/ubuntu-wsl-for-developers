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

# Install Podman and Podman Compose
echo "Installing podman and podman-compose"
apt install podman -y
pip3 install podman-compose

# Install Java 17
echo "Installing $JAVA_VERSION"
apt install $JAVA_VERSION -y

# Install Java 17
echo "Installing $MAVEN"
apt install $MAVEN -y

echo "All components installed successfully."
