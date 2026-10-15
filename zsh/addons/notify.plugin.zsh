# Telegram notification when a long-running command finishes.
# Needs TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID (e.g. exported in ~/.zshrc.local) and bin/telegram.sh.
: ${NOTIFY_THRESHOLD:=60}  # seconds
# Interactive programs that are expected to run long
(( ${+NOTIFY_IGNORE} )) || NOTIFY_IGNORE=(vim nvim hx nano ssh tmux less man top htop btop bottom btm lazygit lzg lazydocker lzd fzf watch)

zmodload zsh/datetime
autoload -Uz add-zsh-hook

_notify_preexec() {
    _notify_cmd="${1}"
    _notify_start="${EPOCHSECONDS}"
}

_notify_precmd() {
    local exit_code=$?
    [[ -n "${_notify_start}" ]] || return
    local elapsed=$(( EPOCHSECONDS - _notify_start ))
    local cmd="${_notify_cmd}"
    unset _notify_start _notify_cmd

    (( elapsed >= NOTIFY_THRESHOLD )) || return
    [[ -n "${TELEGRAM_BOT_TOKEN}" && -n "${TELEGRAM_CHAT_ID}" ]] || return
    type -p telegram.sh &> /dev/null || return
    local first="${${(z)cmd}[1]}"
    (( ${NOTIFY_IGNORE[(Ie)${first}]} )) && return

    local state="done"
    (( exit_code != 0 )) && state="failed (exit ${exit_code})"
    print -r -- "${HOST}: '${cmd}' ${state} after ${elapsed}s" \
        | telegram.sh &> /dev/null &!
}

add-zsh-hook preexec _notify_preexec
add-zsh-hook precmd _notify_precmd
