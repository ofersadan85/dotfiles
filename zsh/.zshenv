# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# ZSH
export ZDOTDIR="$HOME/.config/zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"
export DISABLE_UPDATE_PROMPT="true"
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/.zcompdump-$(hostname)-${ZSH_VERSION}"

# History management
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# make "less" better
# X = leave content on-screen
# F = quit automatically if less than one screenfull
# R = raw terminal characters (fixes git diff)
#     see http://jugglingbits.wordpress.com/2010/03/24/a-better-less-playing-nice-with-git/
export LESS="-F -X -R"

# Rust
export CARGO_TARGET_DIR="${HOME}/.cargo/target"
export CARGO_INCREMENTAL=1
export RUST_BACKTRACE=1

# Python
export PYTHONPYCACHEPREFIX="${HOME}/.cache/pycache"

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export TZ="Asia/Jerusalem"
export EDITOR=nvim
export GPG_TTY=$(tty)
export TMUX_THEME="nord"

