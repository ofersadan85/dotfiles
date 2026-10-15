# --- zsh-autosuggestions ---
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source "${ZDOTDIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"

export GPG_TTY=$(tty)

# --- Completions ---
# All fpath additions must come before compinit, otherwise the new completions are ignored
autoload -Uz compinit
fpath=("${ZDOTDIR}/zsh-completions/src" "${ZDOTDIR}/completions" $fpath)
# Only rebuild the completion dump once a day, otherwise trust the cache (-C) for a faster startup
zmodload zsh/datetime
zmodload -F zsh/stat b:zstat
_zcompdump="${ZSH_COMPDUMP:-${XDG_CACHE_HOME:-$HOME/.cache}/.zcompdump-${ZSH_VERSION}}"
mkdir -p "${_zcompdump:h}"
if [[ -f "${_zcompdump}" ]] && (( EPOCHSECONDS - $(zstat +mtime "${_zcompdump}") < 86400 )); then
    compinit -C -d "${_zcompdump}"
else
    compinit -d "${_zcompdump}"
fi
unset _zcompdump

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
