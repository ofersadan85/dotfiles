#/bin/sh

set -x

sudo apt update && sudo apt install -y \
    btop \
    ca-certificates \
    curl \
    fzf \
    gcc \
    git \
    gpg \
    python3-pip \
    python3-venv \
    python-is-python3 \
    sudo \
    tmux \
    unzip \
    zsh


chsh --shell $(which zsh) $(whoami)

DOTFILES_SKIP_CLONE=${DOTFILES_SKIP_CLONE:-false}
if [ "$DOTFILES_SKIP_CLONE" = "false" ]; then
    if [ -d ~/.config ]; then
        mv ~/.config ~/.config.bak
    fi
    git clone https://github.com/ofersadan85/dotfiles ~/.config
fi

DOTFILES_SKIP_INSTALL=${DOTFILES_SKIP_INSTALL:-false}
if [ "$DOTFILES_SKIP_INSTALL" = "false" ]; then
    bash ~/.config/install.sh
fi
