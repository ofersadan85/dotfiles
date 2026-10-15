# Agent instructions for this repository

This file provides repository-specific guidance for AI coding agents. Keep instructions here generic enough to work across agent tools while still reflecting how this repo is intentionally organized.

## Overview

This is a personal dotfiles repository. It is meant to be cloned to `~/.config`, so configs such as `nvim/`, `helix/`, `tmux/`, and `starship.toml` are picked up in place via XDG. Only some parts need linking or installation; see below. There is no application build/test suite beyond the Docker install validation.

## Core repo conventions

- Prefer small, targeted changes that match existing repo patterns.
- Preserve the cross-platform intent of the repo: Linux/macOS shell configuration and Windows PowerShell configuration both matter.
- Do not add secrets or credentials into tracked files.
- Respect the user's home-directory installation model; avoid hard-coding paths that assume a non-standard layout.
- If a change affects shell aliases, tooling, or install flows, check the existing config before proposing new commands or shortcuts.

## Commands

- `just build` — build the Debian test image (`Dockerfile` runs `bootstrap.sh` with clone and install skipped).
- `just test` — run the container with the repo mounted at `/root/.config`, dropping into `zsh` to verify the shell setup (run `~/.config/install.sh` inside to test linking).
- `just update` — update submodules to their latest upstream commits.
- `just lint` — run all prek hooks on every file.
- Pre-commit hooks use [prek](https://prek.j178.dev) (`.pre-commit-config.yaml`, builtin hooks only): JSON/TOML/YAML validity, `pretty-format-json --no-sort-keys`, EOF/whitespace/mixed line endings, shebang/executable checks, no new submodules, private-key detection.

## Architecture

- **Linux install flow**: `bootstrap.sh` (apt packages, chsh to zsh, clones repo to `~/.config`; honors `DOTFILES_SKIP_CLONE` / `DOTFILES_SKIP_INSTALL`) → `install.sh` (inits submodules, then symlinks via `file_link`/`dir_link`: `zsh/*` (including dotfiles) → `~`, `cargo/` → `~/.cargo`, `bin/` → `~/.local/bin`, `gnupg/` → `~/.gnupg`; imports GPG key from GitHub and generates an ssh key if missing).
- **Windows install flow**: `bootstrap.ps1` (winget Git, clone to `~\.config`) → `windows/install.ps1` (winget import from `windows/winget.json`, Rust build tools, etc.; falls back to downloading files from the GitHub raw URL when run standalone). `windows/profile.ps1` is the PowerShell profile.
- **Zsh** (`zsh/`): `.zshenv` sets `ZDOTDIR=$HOME/.config/zsh` and history options; `.zshrc` sources, in order: zsh-autosuggestions, completions (`fpath` additions must precede `compinit`; custom completions in `zsh/completions/`, plus `zsh-completions`), every `zsh/addons/*.plugin.zsh` (oh-my-zsh–style plugins: git, docker, uv, sudo, etc.), starship and zoxide if installed, then fast-syntax-highlighting last. Notable addons:
  - `misc.plugin.zsh` holds custom aliases: `lzg`/`lzd` (lazygit/lazydocker), `update`, `dcupdate`, `sshconfig`/`qr`/`qrssh`, `glog`/`gs`, `..`/`...` (via zoxide), and conditional `ls`→lsd, `cat`→bat, `fd`→fdfind, `code`→code-insiders. Check it before suggesting or adding aliases.
  - `notify.plugin.zsh`: Telegram message (via `bin/telegram.sh`) when a command runs longer than `NOTIFY_THRESHOLD` (60s); needs `TELEGRAM_BOT_TOKEN`/`TELEGRAM_CHAT_ID`, e.g. in `~/.zshrc.local`.
  - `nvm.plugin.zsh`: lazy-loads nvm; `.zshenv` only puts the newest installed node on PATH.
  - `zz-local.plugin.zsh`: sources untracked `~/.zshrc.local`; the `zz-` prefix makes it load last so it can override other addons.
- **Cross-platform CLI tools**: `cargo/tooling.sh` and `cargo/tooling.ps1` install `cargo-binstall` and then every crate in `cargo/packages.txt` (bat, bottom, du-dust, fd-find, hexyl, just, lsd, prek, ripgrep, starship, tealdeer, uv, zoxide, etc.; also dev tools like cargo-watch, cargo-nextest, bacon, git-delta, xh). Add new cross-platform tools there rather than to apt/winget.
- **Submodules** (`.gitmodules`): tmux `tpm`, zsh-completions, zsh-autosuggestions, fast-syntax-highlighting, and the `fonts` (MesloLGSNF). They are vendored third-party code; update via submodule commands rather than editing the vendored files directly.
- Other directories are per-tool configs (`git/config`, `nvim`, `helix`, `tmux`, `bat`, `lsd`, `fastfetch`, `tealdeer`, `nano`, `pip`, `ssh`, `starship.toml`). `bin/` holds Telegram notification scripts.

## Agent guidance

- Prefer repo-native tooling and install paths (`just`, `bootstrap.sh`, `bootstrap.ps1`, `install.sh`) over ad hoc edits.
- If you add or change alias names, check `zsh/addons/` and existing conventions before introducing new ones.
- If you add a tool or package, prefer adding it to the shared cross-platform lists (`cargo/packages.txt`, `cargo/tooling.*`) instead of duplicating install logic across OS-specific scripts.
- When editing templates or scripts, keep them portable and shell-safe; avoid bashisms in files intended for zsh or PowerShell without careful cross-platform handling.
- When a repo-specific action is required for validation, prefer the smallest command that matches the change; for dotfiles, `just lint` and targeted install validation are usually sufficient.
- Treat vendored submodules as third-party dependencies. Update them via git submodule commands, not by editing their contents in place.
