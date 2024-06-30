#!/bin/bash

## REGION Functions
declare -a fonts=(
    FiraCode
    Hack
    JetBrainsMono
    Meslo
)
##

# Exit immediately if a command exits with a non-zero status
set -e

# Define variables
USER_NAME=developer
FONTS_VERSION='2.1.0'
FONTS_DIR="/home/${USER_NAME}/.local/share/fonts"

# Create user and add to sudo group
useradd -m $USER_NAME
echo -e "$USER_NAME\n$USER_NAME" | passwd $USER_NAME
sudo usermod -aG sudo $USER_NAME

# Add oh my zsh and p10k
runuser -u $USER_NAME -- sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "$USER_NAME" | runuser -u $USER_NAME -- chsh -s $(which zsh)
runuser -u $USER_NAME -- git clone https://github.com/romkatv/powerlevel10k.git /home/${USER_NAME}/.oh-my-zsh/themes/powerlevel10k

if [[ ! -d "$FONTS_DIR" ]]; then
    mkdir -p "$FONTS_DIR"
fi

for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONTS_VERSION}/${zip_file}"
    echo "Downloading $download_url"
    wget "$download_url"
    unzip "$zip_file" -d "$FONTS_DIR"
    rm "$zip_file"
done

find "$FONTS_DIR" -name '*Windows Compatible*' -delete
runuser -u $USER_NAME -- fc-cache -fv

echo "User configuration completed successfully."