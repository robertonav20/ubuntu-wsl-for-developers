#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define variables
FONTS_VERSION='2.1.0'
FONTS_DIR="/home/${USER_NAME}/.local/share/fonts"

# Add password to root user
echo -e "password\npassword" | passwd root

# Create user and add to sudo group
useradd -m $USER_NAME
echo -e "$USER_NAME\n$USER_NAME" | passwd $USER_NAME
sudo usermod -aG sudo $USER_NAME
sudo usermod -aG docker $USER_NAME
sudo tee -a /etc/wsl.conf << EOF
[user]
default=$USER_NAME
EOF

# Add oh my zsh and p10k
runuser -u $USER_NAME -- sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "$USER_NAME" | runuser -u $USER_NAME -- chsh -s $(which zsh)
runuser -u $USER_NAME -- git clone https://github.com/romkatv/powerlevel10k.git /home/${USER_NAME}/.oh-my-zsh/themes/powerlevel10k
runuser -u $USER_NAME -- git clone https://github.com/zsh-users/zsh-autosuggestions /home/${USER_NAME}/.oh-my-zsh/plugins/zsh-autosuggestions
runuser -u $USER_NAME -- git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/${USER_NAME}/.oh-my-zsh/plugins/zsh-syntax-highlighting
runuser -u $USER_NAME -- git clone https://github.com/zsh-users/zsh-completions.git /home/${USER_NAME}/.oh-my-zsh/plugins/zsh-completions
runuser -u $USER_NAME -- git clone https://github.com/zsh-users/zsh-history-substring-search.git /home/${USER_NAME}/.oh-my-zsh/plugins/zsh-history-substring-search
runuser -u $USER_NAME -- git clone https://github.com/marlonrichert/zsh-autocomplete.git /home/${USER_NAME}/.oh-my-zsh/plugins/zsh-autocomplete

# Configure .zshrc
sudo tee -a /home/${USER_NAME}/.zshrc << EOF

# Environment Variables
export PATH=\$PATH:\$HOME/.local/bin
export ZSH=\$HOME/.oh-my-zsh

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load ZSH
source \$ZSH/oh-my-zsh.sh

# Terminal autocomplete fix
autoload -Uz compinit && compinit -i

plugins=(
    git
    docker
    asdf
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    zsh-syntax-highlighting
    zsh-autocomplete
)
source /home/${USER_NAME}/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/${USER_NAME}/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

typeset -g POWERLEVEL9K_DIR_BACKGROUND=25
typeset -g POWERLEVEL9K_DIR_FOREGROUND=15
typeset -g POWERLEVEL9K_TIME_BACKGROUND=25
typeset -g POWERLEVEL9K_TIME_FOREGROUND=15
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=15
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=214
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=15
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=214
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=15
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=214

EOF

declare -a fonts=(
    FiraCode
    Hack
    JetBrainsMono
    Meslo
)
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
exit 0