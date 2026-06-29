# Dotfiles

My personal dotfiles, use at your own risk

## Install

```sh
git clone git@github.com:ofersadan85/dotfiles.git ~/.config
~/.config/install.sh
```

## Full bootstrap

### Linux

For a quick install that includes all of the common apps (requires at least `sudo` and `curl`):

```sh
curl -fsSL https://raw.githubusercontent.com/ofersadan85/dotfiles/refs/heads/main/bootstrap.sh | sh
```

### Windows

For a quick install that includes all of the common apps:

```powershell
Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/ofersadan85/dotfiles/refs/heads/main/bootstrap.ps1 -UseBasicParsing).Content
```
