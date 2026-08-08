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

ZSH_PLUGINS="${HOME}/.config/zsh"
ZSH_CUSTOM="${ZSH_PLUGINS}/ohmyzsh"
ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
autoload -Uz is-at-least
mkdir -p ${ZSH_CACHE_DIR}/completions

plugins=(
  command-not-found
  docker
  docker-compose
  extract
  gh
  git
  git-auto-fetch
  gitignore
  history
  jsontools
  magic-enter
  rust
  sudo
  systemadmin
  systemd
  tmux
  uv
)

is_plugin() {
  local base_dir=$1
  local name=$2
  builtin test -f $base_dir/plugins/$name/$name.plugin.zsh \
    || builtin test -f $base_dir/plugins/$name/_$name
}

# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
  if is_plugin "$ZSH_CUSTOM" "$plugin"; then
    fpath=("$ZSH_CUSTOM/plugins/$plugin" $fpath)
    source "$ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh"
  else
    echo "[oh-my-zsh] plugin '$plugin' not found in $ZSH -OR- $ZSH_CUSTOM"
  fi
done
unset plugin

# zsh-completions
fpath=("${ZSH_PLUGINS}/zsh-completions/src" $fpath) && autoload -Uz compinit && compinit

# zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source "${ZSH_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh"

source "${HOME}/.aliases"

if type -p starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
if type -p zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# zsh-syntax-highlighting must be sourced at the end of .zshrc
source "${ZSH_PLUGINS}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
