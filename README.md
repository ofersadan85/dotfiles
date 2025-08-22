# Dotfiles

My personal dotfiles, use at your own risk

## Install

### Linux/macOS

```sh
git clone git@github.com:ofersadan85/dotfiles.git ~/.config
~/.config/install.sh
```

### Windows

```powershell
# Clone to a local directory (not ~/.config on Windows)
git clone https://github.com/ofersadan85/dotfiles.git $env:USERPROFILE\dotfiles
cd $env:USERPROFILE\dotfiles

# Run as Administrator for symbolic links (recommended)
Start-Process PowerShell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File install.ps1"

# Or run normally (will copy files instead of linking)
powershell -ExecutionPolicy Bypass -File install.ps1
```

#### Windows Prerequisites

The install script will check for and guide you to install these tools:

- **Git**: `winget install Git.Git`
- **Neovim**: `winget install Neovim.Neovim`
- **ripgrep**: `winget install BurntSushi.ripgrep.MSVC` (for telescope fuzzy finding)
- **PowerShell Core**: `winget install Microsoft.PowerShell` (optional, better than Windows PowerShell)

#### Windows-Specific Features

- **Neovim Configuration**: Automatically placed in `%LOCALAPPDATA%\nvim`
- **Clipboard Integration**: Enhanced clipboard support with win32yank
- **Build Tools**: Improved telescope-fzf-native with cmake/make fallbacks
- **Shell Integration**: PowerShell configuration improvements
- **Health Checks**: Windows-specific tool recommendations via `:checkhealth`

## Features

- **Neovim**: Kickstart-based configuration with Windows compatibility
- **Git**: Enhanced configuration and aliases
- **Shell**: ZSH (Linux/macOS) / PowerShell (Windows) improvements
- **Tools**: Various development utilities and configurations

