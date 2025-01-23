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

install_neovim() {
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  rm nvim-linux64.tar.gz
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

export NVIM_PATH="/opt/nvim-linux64/bin"
[[ -d "${NVIM_PATH}/ ]] export PATH="$PATH:$NVIM_PATH" || echo "Neovim not installed, run `install_neovim`"

