#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define installation directory
INSTALL_DIR=/opt

# Update packages repositories
sudo apt-get update

# Define variables
PYTHON_VERSION=python3-pip
NVM_VERSION=v0.40.3
NODE_VERSION=20
JAVA_VERSION=17.0.2
MAVEN_VERSION=3.9.9
GO_VERSION=1.24.2
OLLAMA=1.24.2

# Install Python 3
echo "Installing $PYTHON_VERSION"
apt install -y $PYTHON_VERSION

# Install NodeJS (Node Version Manager)
echo "Installing ${NODE_VERSION}"
export NVM_DIR=${INSTALL_DIR}/.nvm
mkdir -p ${NVM_DIR}
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
source ${NVM_DIR}/nvm.sh
nvm install ${NODE_VERSION}
echo -e "source ${NVM_DIR}/nvm.sh" | tee -a /etc/zsh/zshenv

# Install Java 17
echo "Installing ${JAVA_VERSION}"
wget https://download.java.net/java/GA/jdk${JAVA_VERSION}/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz -P ./
tar xzf openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz -C ${INSTALL_DIR}
ln -s ${INSTALL_DIR}/jdk-${JAVA_VERSION} ${INSTALL_DIR}/java
tee -a /etc/profile.d/java.sh << EOF
export JAVA_HOME=${INSTALL_DIR}/java
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
echo -e "source /etc/profile.d/java.sh" | tee -a /etc/zsh/zshenv
rm openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz

# Install MAVEN
echo "Installing $MAVEN"
wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -P ./
tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C ${INSTALL_DIR}
ln -s ${INSTALL_DIR}/apache-maven-${MAVEN_VERSION} ${INSTALL_DIR}/maven
tee -a /etc/profile.d/maven.sh << EOF
export M2_HOME=${INSTALL_DIR}/maven
export MAVEN_HOME=${INSTALL_DIR}/maven
export PATH=\$MAVEN_HOME/bin:\$PATH
EOF
echo -e "source /etc/profile.d/maven.sh" | tee -a /etc/zsh/zshenv
rm apache-maven-${MAVEN_VERSION}-bin.tar.gz

# Install Go 1.24
echo "Installing ${GO_VERSION}"
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -P ./
mkdir -p ${INSTALL_DIR}/go-${GO_VERSION}
tar xzf go${GO_VERSION}.linux-amd64.tar.gz -C ${INSTALL_DIR}/go-${GO_VERSION}
ln -s ${INSTALL_DIR}/go-${GO_VERSION}/go ${INSTALL_DIR}/go
tee -a /etc/profile.d/go.sh << EOF
export GO_HOME=${INSTALL_DIR}/go
export PATH=\$GO_HOME/bin:\$PATH
EOF
echo -e "source /etc/profile.d/go.sh" | tee -a /etc/zsh/zshenv
rm go${GO_VERSION}.linux-amd64.tar.gz

# Install Docker and Docker Compose
echo "Installing docker and docker-compose"

# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker
if [ $(getent group docker) ]; then
    echo "Docker group already exists."
else
    groupadd docker
fi
systemctl enable docker.service
systemctl enable containerd.service

echo "All components installed successfully."
exit 0
