$REPO_RAW_BASE = "https://raw.githubusercontent.com/ofersadan85/dotfiles/main/windows"
$LOCAL_REPO = Split-Path -Path $PSScriptRoot -Parent

function ensure_directory ($path) { New-Item -ItemType Directory -Force -Path $path | Out-Null }

function update_session_path {
    $machine_path = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $user_path = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = (@($machine_path, $user_path) | Where-Object { $_ }) -join ';'

    foreach ($extra_path in @(
            (Join-Path -Path $HOME -ChildPath ".cargo\bin"),
            (Join-Path -Path $HOME -ChildPath ".local\bin")
        )) {
        if ((Test-Path -Path $extra_path) -and ($env:Path -notlike "*$extra_path*")) {
            $env:Path = "$env:Path;$extra_path"
        }
    }
}

function setup_modules {
    Write-Host "Installing required modules..."
    Install-Module -AcceptLicense DockerCompletion
    Install-Module -AcceptLicense DockerComposeCompletion
}

function setup_winget {
    Write-Host "Setting up winget packages..."
    $winget_src = Join-Path -Path $PSScriptRoot -ChildPath "winget.json"
    if (Test-Path -Path $winget_src) {
        $winget_tmp = $winget_src
    }
    else {
        $winget_tmp = Join-Path -Path $env:TEMP -ChildPath "winget.json"
        Invoke-WebRequest -Uri "$REPO_RAW_BASE/winget.json" -OutFile $winget_tmp
    }
    winget import `
        --verbose `
        --accept-package-agreements `
        --accept-source-agreements `
        --disable-interactivity `
        --ignore-unavailable `
        --no-upgrade `
        --import-file $winget_tmp
    update_session_path
}

function setup_rust_build_tools {
    Write-Host "Setting up native Rust build tools..."
    winget install `
        --id Microsoft.VisualStudio.2022.BuildTools `
        --exact `
        --no-upgrade `
        --accept-package-agreements `
        --accept-source-agreements `
        --silent `
        --override "--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --passive --norestart"
}

function setup_profile {
    $profile_parent = Split-Path -Path $PROFILE -Parent
    $theme_name = "omp.yaml"
    $profile_path = Join-Path -Path $PSScriptRoot -ChildPath "profile.ps1"
    $theme_path = Join-Path -Path $PSScriptRoot -ChildPath $theme_name

    ensure_directory $profile_parent

    if ((Test-Path -Path (Join-Path -Path $profile_parent -ChildPath ".git"))) {
        Write-Host "Profile directory is already a git repository. Pulling latest changes..."
        git -C $profile_parent pull
        return
    }

    $theme_dest = Join-Path -Path $profile_parent -ChildPath $theme_name
    Write-Host "Setting up symbolic links requires administrator privileges"
    Write-Host "Run these commands as administrator:"
    Write-Host "New-Item -ItemType SymbolicLink -Path $PROFILE -Target $profile_path"
    Write-Host "New-Item -ItemType SymbolicLink -Path $theme_dest -Target $theme_path"
}

function setup_extra_packages {
    Write-Host "Setting up cargo packages..."
    # See https://github.com/cargo-bins/cargo-binstall#windows
    $binstall_url = "https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.ps1"
    Set-ExecutionPolicy Unrestricted -Scope Process; Invoke-Expression (Invoke-WebRequest $binstall_url).Content
    cargo binstall --no-confirm `
        bat `
        bottom `
        cargo-binstall `
        cargo-expand `
        cargo-generate `
        cargo-update `
        du-dust `
        fd-find `
        hexyl `
        just `
        lsd `
        prek `
        ripgrep `
        tealdeer `
        tree-sitter-cli `
        uv `
        zoxide
    cargo install-update cargo-binstall --force  # Bug fix: cargo-binstall contains removed executables (cargo-binstall)
    
    ##############################################
    # Extra UV tools
    ##############################################
    update_session_path
    uv tool install --upgrade ruff
    uv tool install --upgrade ty
}

function setup_neovim {
    Write-Host "Setting up Neovim..."
    $REPO_NVIM_DIR = Join-Path -Path $LOCAL_REPO -ChildPath "nvim"
    $NVIM_CONFIG_DIR = Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvim"
    if (Test-Path -Path $NVIM_CONFIG_DIR) {
        Write-Host "Neovim config directory already exists. Skipping setup."
        return
    }
    New-Item -ItemType Junction -Path $NVIM_CONFIG_DIR -Target $REPO_NVIM_DIR
}

#############################################
# Main
#############################################
setup_modules
setup_winget  # Must include git for the next step to work
setup_rust_build_tools
setup_extra_packages
setup_neovim
setup_profile
