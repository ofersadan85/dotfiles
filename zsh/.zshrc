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
if type -p zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

