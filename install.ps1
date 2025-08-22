# PowerShell install script for dotfiles on Windows
# Run with: powershell -ExecutionPolicy Bypass -File install.ps1

param(
    [switch]$SkipNeovim,
    [switch]$SkipGit
)

# Enable verbose output
$VerbosePreference = "Continue"

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Helper function to check if running as administrator
function Test-Administrator {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Helper function to clone git repositories
function Git-CloneIfNeeded {
    param(
        [string]$TargetFolder,
        [string]$GitRepo
    )
    
    if (Test-Path $TargetFolder) {
        Write-Host "Folder already exists: $TargetFolder"
    } else {
        Write-Host "Cloning to: $TargetFolder"
        git clone --depth=1 $GitRepo $TargetFolder
    }
}

# Helper function to create symbolic links (requires admin) or copy files
function Create-Link {
    param(
        [string]$Source,
        [string]$Target
    )
    
    if (Test-Path $Target) {
        Remove-Item $Target -Force
    }
    
    # Try to create symbolic link first (requires admin privileges)
    if (Test-Administrator) {
        try {
            New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
            Write-Host "Linked: $Target -> $Source"
            return
        } catch {
            Write-Warning "Failed to create symbolic link, falling back to copy"
        }
    }
    
    # Fall back to copying
    if (Test-Path $Source -PathType Container) {
        Copy-Item $Source $Target -Recurse -Force
        Write-Host "Copied directory: $Source -> $Target"
    } else {
        Copy-Item $Source $Target -Force
        Write-Host "Copied file: $Source -> $Target"
    }
}

# Helper function to link directory contents
function Link-DirectoryContents {
    param(
        [string]$SourceDir,
        [string]$DestinationDir = $env:USERPROFILE
    )
    
    $FullSourceDir = Join-Path $ScriptDir $SourceDir
    
    if (-not (Test-Path $DestinationDir)) {
        New-Item -ItemType Directory -Path $DestinationDir -Force | Out-Null
    }
    
    Get-ChildItem $FullSourceDir -Force | ForEach-Object {
        $Target = Join-Path $DestinationDir $_.Name
        Create-Link $_.FullName $Target
    }
}

# Check for required tools
function Test-RequiredTools {
    Write-Host "Checking for required tools..."
    
    $tools = @("git", "curl")
    $missing = @()
    
    foreach ($tool in $tools) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            $missing += $tool
        } else {
            Write-Host "✓ Found: $tool"
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Warning "Missing required tools: $($missing -join ', ')"
        Write-Host "Please install missing tools using one of:"
        Write-Host "  - winget install Git.Git"
        Write-Host "  - winget install cURL.cURL" 
        Write-Host "  - Or download from their official websites"
        return $false
    }
    
    return $true
}

# Install PowerShell equivalent of oh-my-zsh (optional)
function Install-PowerShellProfile {
    Write-Host "Setting up PowerShell profile..."
    
    # Check if PowerShell profile exists
    if (-not (Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
        Write-Host "Created PowerShell profile: $PROFILE"
    }
    
    # Add some basic improvements to profile if not already present
    $profileContent = @"
# Added by dotfiles installer
# Set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Set location to user directory on startup
Set-Location `$env:USERPROFILE

# Useful aliases
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name la -Value Get-ChildItem
Set-Alias -Name vim -Value nvim -ErrorAction SilentlyContinue

"@

    $currentContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    if (-not $currentContent -or $currentContent -notmatch "Added by dotfiles installer") {
        Add-Content $PROFILE $profileContent
        Write-Host "Updated PowerShell profile with dotfiles configuration"
    }
}

# Install Neovim configuration
function Install-NeovimConfig {
    Write-Host "Installing Neovim configuration..."
    
    # Determine Neovim config directory
    $NvimConfigDir = if ($env:XDG_CONFIG_HOME) {
        Join-Path $env:XDG_CONFIG_HOME "nvim"
    } else {
        Join-Path $env:LOCALAPPDATA "nvim"
    }
    
    Write-Host "Neovim config directory: $NvimConfigDir"
    
    # Backup existing config if it exists
    if (Test-Path $NvimConfigDir) {
        $BackupDir = "$NvimConfigDir.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Write-Host "Backing up existing config to: $BackupDir"
        Move-Item $NvimConfigDir $BackupDir
    }
    
    # Create parent directory
    $ParentDir = Split-Path $NvimConfigDir -Parent
    if (-not (Test-Path $ParentDir)) {
        New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
    }
    
    # Link/copy nvim config
    $SourceNvimDir = Join-Path $ScriptDir "nvim"
    Create-Link $SourceNvimDir $NvimConfigDir
    
    Write-Host "Neovim configuration installed successfully!"
    Write-Host "Run 'nvim' to start Neovim and install plugins automatically."
}

# Check if Neovim is installed
function Test-NeovimInstalled {
    if (Get-Command nvim -ErrorAction SilentlyContinue) {
        $nvimVersion = nvim --version | Select-Object -First 1
        Write-Host "✓ Found: $nvimVersion"
        return $true
    } else {
        Write-Host "✗ Neovim not found"
        Write-Host "Please install Neovim using one of:"
        Write-Host "  - winget install Neovim.Neovim"
        Write-Host "  - choco install neovim"
        Write-Host "  - scoop install neovim"
        Write-Host "  - Download from: https://github.com/neovim/neovim/releases"
        return $false
    }
}

# Main installation process
Write-Host "=== Dotfiles Installation for Windows ===" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
if (Test-Administrator) {
    Write-Host "✓ Running as Administrator - symbolic links will be used" -ForegroundColor Green
} else {
    Write-Host "⚠ Not running as Administrator - files will be copied instead of linked" -ForegroundColor Yellow
    Write-Host "  For symbolic links, run as Administrator with: Start-Process PowerShell -Verb RunAs"
}

Write-Host ""

# Check for required tools
if (-not (Test-RequiredTools)) {
    Write-Error "Please install required tools and run the script again."
    exit 1
}

# Initialize and update git submodules
Write-Host "Initializing git submodules..."
Set-Location $ScriptDir
git submodule init
git submodule update

# Install PowerShell profile improvements
Install-PowerShellProfile

# Link home directory files
Write-Host "Linking home directory files..."
Link-DirectoryContents "home"

# Create .local/bin equivalent (user PATH)
$LocalBinDir = Join-Path $env:USERPROFILE ".local\bin"
if (-not (Test-Path $LocalBinDir)) {
    New-Item -ItemType Directory -Path $LocalBinDir -Force | Out-Null
}
Link-DirectoryContents "bin" $LocalBinDir

# Add .local/bin to PATH if not already present
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$LocalBinDir*") {
    $newPath = "$currentPath;$LocalBinDir"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    Write-Host "Added $LocalBinDir to user PATH"
}

# Install Neovim configuration
if (-not $SkipNeovim) {
    if (Test-NeovimInstalled) {
        Install-NeovimConfig
    } else {
        Write-Warning "Skipping Neovim configuration (Neovim not installed)"
    }
}

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Restart your terminal to apply PATH changes"
Write-Host "2. Install Neovim if not already installed: winget install Neovim.Neovim"
Write-Host "3. Run 'nvim' to start Neovim and install plugins"
Write-Host "4. Install additional tools as needed:"
Write-Host "   - Git: winget install Git.Git"
Write-Host "   - ripgrep: winget install BurntSushi.ripgrep.MSVC"
Write-Host "   - fd: winget install sharkdp.fd"
Write-Host "   - Node.js: winget install OpenJS.NodeJS"
Write-Host ""

# Optional: Ask to install common tools
$response = Read-Host "Would you like to install common development tools via winget? (y/N)"
if ($response -eq 'y' -or $response -eq 'Y') {
    Write-Host "Installing common tools..."
    
    $tools = @(
        "BurntSushi.ripgrep.MSVC",
        "sharkdp.fd", 
        "OpenJS.NodeJS",
        "Microsoft.PowerShell"
    )
    
    foreach ($tool in $tools) {
        Write-Host "Installing $tool..."
        winget install $tool --accept-source-agreements --accept-package-agreements
    }
}

Write-Host "Done!" -ForegroundColor Green