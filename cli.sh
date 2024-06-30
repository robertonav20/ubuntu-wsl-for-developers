#!/bin/bash

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
    #$name --version
}

# Function to download and install a binary from a tar.gz archive
install_binary_from_archive() {
    local name=$1
    local url=$2
    local source_path=$3
    local install_path=$4

    local filename=$(basename $url)
    local extension="${filename##*.}"

    echo "Downloading $url..."
    curl -Lo ${name}.${extension} $url
    ls -la
    
    echo "Extracting ${name}.${extension}"
    echo "Debug ${filename} ${extension}"

    if [[ "$extension" == "*.gz" || "$extension" == "*.tar.gz" ]]; then
        tar -xvf ${name}.${extension}
    elif [ "$extension" == "*.zip" ]; then
        unzip ${name}.${extension}
    else
        echo "Unsupported file extension: $extension"
        exit 1
    fi

    chmod +x $source_path
    sudo mv $source_path $install_path
    rm -rf ${name}.${extension} ${name}
    echo "$name installed at $(which $name)"
}
##

# Exit immediately if a command exits with a non-zero status
set -e

# Define versions
HELM_VERSION="v3.12.3"
K3D_VERSION=$(curl -s https://api.github.com/repos/k3d-io/k3d/releases/latest | grep 'tag_name' | cut -d\" -f4)
KAMEL_VERSION=$(curl -s https://api.github.com/repos/apache/camel-k/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed 's/v//')
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
KNATIVE_VERSION=$(curl -s https://api.github.com/repos/knative/client/releases/latest | grep 'tag_name' | cut -d\" -f4)
TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed 's/v//')
TILT_VERSION=$(curl -s https://api.github.com/repos/tilt-dev/tilt/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed 's/v//')
TILT_CTLPTL_VERSION=$(curl -s https://api.github.com/repos/tilt-dev/ctlptl/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed 's/v//')
TRACETEST_VERSION=$(curl -s https://api.github.com/repos/kubeshop/tracetest/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed 's/v//')

# Define installation directory
INSTALL_DIR="/usr/local/bin"

# Download and install kubectl
install_binary "kubectl" "https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" "$INSTALL_DIR/kubectl"

# Download and install k3d
install_binary "k3d" "https://github.com/k3d-io/k3d/releases/download/$K3D_VERSION/k3d-linux-amd64" "$INSTALL_DIR/k3d"

# Download and install Terraform
install_binary_from_archive "terraform" "https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_linux_amd64.zip" "terraform" "$INSTALL_DIR/terraform"

# Download and install Helm
install_binary_from_archive "helm" "https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz" "linux-amd64/helm" "$INSTALL_DIR/helm"

# Download and install DevSpace
install_binary "devspace" "https://github.com/loft-sh/devspace/releases/latest/download/devspace-linux-amd64" "$INSTALL_DIR/devspace"

# Install Knative CLI (kn)
install_binary "kn" "https://github.com/knative/client/releases/download/$KNATIVE_VERSION/kn-linux-amd64" "$INSTALL_DIR/kn"

# Install Tracetest CLI (tracetest)
install_binary_from_archive "tracetest" "https://github.com/kubeshop/tracetest/releases/download/$TRACETEST_VERSION/tracetest_${TRACETEST_VERSION}_linux_amd64.tar.gz" "tracetest" "$INSTALL_DIR/tracetest"

# Install Tilt CLI (tilt)
install_binary_from_archive "tilt" "https://github.com/tilt-dev/tilt/releases/download/v$TILT_VERSION/tilt.$TILT_VERSION.linux.x86_64.tar.gz" "tilt" "$INSTALL_DIR/tilt"

# Install Tilt Ctlptl CLI (ctlptl)
install_binary_from_archive "ctlptl" "https://github.com/tilt-dev/ctlptl/releases/download/v$TILT_CTLPTL_VERSION/ctlptl.$TILT_CTLPTL_VERSION.linux.x86_64.tar.gz" "ctlptl" "$INSTALL_DIR/ctlptl"

# Install Kamel CLI (kamel)
install_binary_from_archive "kamel" "https://github.com/apache/camel-k/releases/download/v$KAMEL_VERSION/camel-k-client-$KAMEL_VERSION-linux-amd64.tar.gz" "kamel" "$INSTALL_DIR/kamel"

# Install AWS CLI (aws)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir $INSTALL_DIR --install-dir $INSTALL_DIR/aws-cli --update

# Add to PATH if not already in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Adding $INSTALL_DIR to PATH..."
    echo "export PATH=\$PATH:$INSTALL_DIR" >> ~/.bashrc
    source ~/.bashrc
else
    echo "$INSTALL_DIR already in PATH"
fi

echo "All commmands installed successfully."
