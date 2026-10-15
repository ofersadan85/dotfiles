# Lazy-load nvm: sourcing nvm.sh costs several hundred ms per shell, so only do it on first use.
# (The newest installed node is already on PATH, see .zshenv.)
[[ -s "${NVM_DIR}/nvm.sh" ]] || return

nvm() {
    unfunction nvm
    source "${NVM_DIR}/nvm.sh"
    [[ -s "${NVM_DIR}/bash_completion" ]] && source "${NVM_DIR}/bash_completion"
    nvm "$@"
}
