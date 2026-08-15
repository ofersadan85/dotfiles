# --- zsh-autosuggestions ---
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source "${ZDOTDIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"

# --- Completions ---
# All fpath additions must come before compinit, otherwise the new completions are ignored
autoload -Uz compinit
fpath=("${ZDOTDIR}/zsh-completions/src" "${ZDOTDIR}/completions" $fpath) && compinit

for file in "${ZDOTDIR}/addons"/*.plugin.zsh; do
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
source "${ZDOTDIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
