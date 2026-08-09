$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

if (-not (Get-Command cargo-binstall -ErrorAction SilentlyContinue)) {
    # See: https://github.com/cargo-bins/cargo-binstall#quickly
    Write-Host "Installing cargo-binstall..."
    Set-ExecutionPolicy Unrestricted -Scope Process -Force
    Invoke-Expression (Invoke-WebRequest "https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.ps1").Content
}

$packagesFile = Join-Path $scriptDir "packages.txt"
if (Test-Path $packagesFile) {
    # Read non-empty lines
    $packages = Get-Content $packagesFile | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    if ($packages) {
        Write-Host "Installing cargo packages: $packages"
        # We invoke cargo binstall and pass the packages array which PowerShell will expand correctly
        cargo binstall --no-confirm $packages
    }
}
