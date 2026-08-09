ZSH_PLUGINS="${HOME}/.config/zsh"

# zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source "${ZSH_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-completions
autoload -Uz compinit  # This is also important for other plugins
fpath=("${ZSH_PLUGINS}/zsh-completions/src" $fpath) && compinit

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

fpath=("${ZSH_PLUGINS}/completions" $fpath) # We're doing compinit later, otherwise: && autoload -Uz compinit && compinit
for file in "${ZSH_PLUGINS}/addons"/*.plugin.zsh; do
    # Skip if no files match
    [[ -e "$file" ]] || continue
    source "${file}"
done
unset file

if type -p starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
if type -p zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# fast-syntax-highlighting
source "${ZSH_PLUGINS}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
