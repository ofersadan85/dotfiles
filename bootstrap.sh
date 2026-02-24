#/bin/sh

set -x

sudo apt update && sudo apt install -y \
    btop \
    ca-certificates \
    curl \
    fd-find \
    fzf \
    gcc \
    git \
    python3-pip \
    python3-venv \
    python-is-python3 \
    ripgrep \
    sudo \
    tmux \
    unzip \
    zoxide \
    zsh

chsh --shell $(which zsh) $(whoami)
[[ -d ~/.config ]] && mv ~/.config ~/.config.bak
git clone https://github.com/ofersadan85/dotfiles ~/.config
~/.config/install.sh
