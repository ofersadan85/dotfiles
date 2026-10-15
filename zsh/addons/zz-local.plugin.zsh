# Machine-specific overrides and secrets, not tracked in git
# The filename `zz-local.plugin.zsh` is important to load last and override
[[ -f "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"
