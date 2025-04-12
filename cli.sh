#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

## REGION Functions

# Function to download and install a binary
install_binary() {
    local name=$1
    local url=$2
    local install_path=$3
    echo "Downloading $url..."
    curl -Lo $name $url
    chmod +x $name
    sudo mv $name $install_path
    echo "$name installed at $(which $name)"
}

# Function to download and install a binary from a tar.gz archive
install_binary_from_archive() {
    local name=$1
    local extension=$2
    local url=$3
    local source_path=$4
    local install_path=$5

    local filename=${name}.${extension}

    echo "Downloading ${filename} from $url"
    curl -Lo ${filename} $url
    ls -la

    echo "Extracting ${filename}"

    if [[ "$extension" == "gz" || "$extension" == "tar.gz" ]]; then
        tar -xvf ${filename}
    elif [ "$extension" == "zip" ]; then
        unzip ${filename}
    else
        echo "Unsupported file extension: $extension"
        exit 1
    fi

    chmod +x $source_path
    sudo mv $source_path $install_path
    rm -rf *
    echo "$name installed at $(which $name)"
}
##

# Define versions
HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep 'tag_name' | cut -d\" -f4)
KIND_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | grep 'tag_name' | cut -d\" -f4)
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
TILT_VERSION=$(curl -s https://api.github.com/repos/tilt-dev/tilt/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed 's/v//')
TILT_CTLPTL_VERSION=$(curl -s https://api.github.com/repos/tilt-dev/ctlptl/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed 's/v//')

# Define installation directory
INSTALL_DIR="/usr/local/bin"

# Download and install kubectl
install_binary "kubectl" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" "${INSTALL_DIR}/kubectl"

# Download and install kind
install_binary "kind" "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64" "${INSTALL_DIR}/kind"

# Download and install Helm
install_binary_from_archive "helm" "tar.gz" "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" "linux-amd64/helm" "${INSTALL_DIR}/helm"

# Install Tilt CLI (tilt)
install_binary_from_archive "tilt" "tar.gz" "https://github.com/tilt-dev/tilt/releases/download/v${TILT_VERSION}/tilt.${TILT_VERSION}.linux.x86_64.tar.gz" "tilt" "${INSTALL_DIR}/tilt"

# Install AWS CLI (aws)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir ${INSTALL_DIR} --install-dir ${INSTALL_DIR}/aws-cli --update

# Install Dagger CLI
curl -fsSL https://dl.dagger.io/dagger/install.sh | BIN_DIR=${INSTALL_DIR} sh

echo "All commmands installed successfully."
exit 0