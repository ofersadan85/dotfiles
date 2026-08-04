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

source "${HOME}/.aliases"

if type -p starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
if type -p zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

