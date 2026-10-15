# fzf: fuzzy finder (Ctrl-R history, Ctrl-T files, Alt-C cd) with fd / ripgrep backends
type -p fzf &> /dev/null || return

# fd is called "fdfind" on Debian
if type -p fd &> /dev/null; then _fzf_fd=fd; elif type -p fdfind &> /dev/null; then _fzf_fd=fdfind; fi

if [[ -n "${_fzf_fd}" ]]; then
    export FZF_DEFAULT_COMMAND="${_fzf_fd} --type f --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
    export FZF_ALT_C_COMMAND="${_fzf_fd} --type d --hidden --follow --exclude .git"
elif type -p rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi
unset _fzf_fd

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Key bindings and completion (fzf >= 0.48 has built-in zsh integration)
source <(fzf --zsh) 2> /dev/null

# Live ripgrep search: rgf <pattern> (opens the match in $EDITOR)
if type -p rg &> /dev/null; then
    rgf() {
        local selected
        selected=$(rg --line-number --no-heading --color=always --smart-case "${@:-}" \
            | fzf --ansi --delimiter : --preview 'bat --color=always --highlight-line {2} {1} 2> /dev/null || cat {1}') \
            || return
        ${EDITOR:-nvim} "+$(cut -d: -f2 <<< "${selected}")" "$(cut -d: -f1 <<< "${selected}")"
    }
fi

# gbr: fuzzy-pick a git branch (local or remote, newest first) and switch to it
gbr() {
    local branch
    branch=$(git branch --all --sort=-committerdate --format='%(refname:short)' \
        | grep -v 'HEAD' \
        | fzf --preview 'git log --oneline --graph --color=always -20 {}') || return
    if [[ "${branch}" == */* ]] && git rev-parse --verify --quiet "refs/remotes/${branch}" > /dev/null; then
        git switch --track "${branch}"
    else
        git switch "${branch}"
    fi
}

# gwt: fuzzy-pick a git worktree and cd into it
gwt() {
    local dir
    dir=$(git worktree list | fzf --preview 'git -C {1} log --oneline --color=always -10' | awk '{print $1}') || return
    [[ -n "${dir}" ]] && cd "${dir}"
}

# dsh: fuzzy-pick a running container and open a shell in it
dsh() {
    local container
    container=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' \
        | fzf --delimiter '\t' --header 'Open a shell in container' | cut -f1) || return
    [[ -n "${container}" ]] || return
    docker exec -it "${container}" sh -c 'command -v bash > /dev/null && exec bash || exec sh'
}
