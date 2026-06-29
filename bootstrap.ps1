winget install `
    --id Git.Git `
    --exact `
    --no-upgrade `
    --accept-package-agreements `
    --accept-source-agreements `
    --silent

$dest = Join-Path -Path $HOME -ChildPath ".config"
if (Test-Path -Path $dest) {
    Write-Host "Config directory already exists. Pulling latest changes..."
    git -C $dest pull
}
else {
    Write-Host "Cloning dotfiles repository to $dest"
    git clone https://github.com/ofersadan85/dotfiles $dest
}
& (Join-Path -Path $dest -ChildPath "windows/install.ps1")
