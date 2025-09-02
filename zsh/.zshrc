# Function to attach to the last tmux session or create a new one
tmux_auto_start() {
  if command -v tmux &> /dev/null; then
    if [ -z "$TMUX" ]; then
      if tmux ls 2>/dev/null | grep -q '^'; then
        # Attach to the last session if it exists
        tmux attach-session -t "$(tmux ls | grep -o '^[^:]*' | tail -n1)"
      else
        # Create a new session if no sessions exist
        tmux new-session -s default
      fi
    fi
  fi
}

NEOVIM_FOLDER=nvim-linux-x86_64
install_neovim() {
  NEOVIM_FILENAME="${NEOVIM_FOLDER}.tar.gz"
  curl -LO "https://github.com/neovim/neovim/releases/latest/download/${NEOVIM_FILENAME}"
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf "${NEOVIM_FILENAME}"
  rm "${NEOVIM_FILENAME}"
}

plugins=(
  aws
  command-not-found
  docker
  docker-compose
  extract
  gcloud
  genpass
  gh
  git
  git-auto-fetch
  gitignore
  history
  jsontools
  kubectl
  magic-enter
  minikube
  pip
  rust
  sudo
  systemadmin
  systemd
  uv
  web-search
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

source "${HOME}/.oh-my-zsh/oh-my-zsh.sh"
source "${HOME}/.p10k.zsh"
source "${HOME}/.aliases"
[[ -d "${HOME}/.local/bin" ]] && export PATH="${HOME}/.local/bin:$PATH"
if type -p zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

export NVIM_PATH="/opt/${NEOVIM_FOLDER}/bin"
[[ -d "${NVIM_PATH}" ]] && export PATH="$PATH:$NVIM_PATH" || echo "Neovim not installed, run 'install_neovim'"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
