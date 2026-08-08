############################################
# Debug / Trace / Timing setup
############################################
$DEBUG_MODE = $false; $SHOW_TIMING = $false; $START_TIME = Get-Date
if ($DEBUG_MODE) { Set-PSDebug -Trace 1 -Strict; $SHOW_TIMING = $true } else { Set-PSDebug -Off }
function WithTiming {
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock
    )
    if ($SHOW_TIMING) {
        Write-Host "$((Measure-Command { & $ScriptBlock }).TotalMilliseconds) ms"
        Write-Host "Execution time: $(((Get-Date) - $START_TIME).TotalMilliseconds) ms"
    }
    else { & $ScriptBlock }
}

############################################
# PSReadLine
############################################
Set-PSReadLineOption `
    -EditMode Emacs `
    -MaximumHistoryCount 100kb `
    -PredictionSource HistoryAndPlugin

############################################
# Utility Functions
############################################
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
function gig {
    # Create .gitignore file using Toptal's API
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$list
    )
    $params = ($list | ForEach-Object { [uri]::EscapeDataString($_) }) -join ","
    Invoke-WebRequest -Uri "https://www.toptal.com/developers/gitignore/api/$params" | Select-Object -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii
}
function reload { . $PROFILE }
function touch ($path) { if (Test-Path -Path $path) { (Get-Item -Path $path).LastWriteTime = Get-Date } else { New-Item -ItemType File -Path $path | Out-Null } }
function path { $env:Path -split ';' }
function glog { git log --oneline --decorate --graph @args }
function gs { git status --short --branch --untracked @args } 
function dps { docker ps @args }
function dcu { docker compose up @args }
function dcd { docker compose down @args }
function .. { z .. }
function ... { z ..\.. }
function cpwd { $PWD.Path | Set-Clipboard }

############################################
# Completions & Initializations
############################################
if (which starship) { Invoke-Expression (&starship init powershell) }
if (which zoxide) { Invoke-Expression (& { (zoxide init powershell | Out-String) }) }
if (which rustup) { Invoke-Expression (& { (rustup completions powershell | Out-String) }) }
if (which gh) { Invoke-Expression (gh completion --shell powershell | Out-String) }

############################################
# Aliases
############################################
function try_alias {
    param (
        [string]$from,
        [string]$to,
        [bool]$override = $false,
        [bool]$silent = $false
    )
    if ((which $from) -and (which $to) -and $override) {
        Write-Host "Both commands exist: $from and $to. Not creating alias."
        return $false
    }
    elseif (which $to) {
        Set-Alias -Name $from -Value $to -Scope Global -Option AllScope -Force
        return $true
    }
    elseif (!$silent) {
        Write-Host "Could not alias: $from -> $to"
        return $false
    }
}

$null = try_alias grep rg
$null = try_alias g git
$null = try_alias c cargo
$null = try_alias code code-insiders -silent $true
$null = try_alias cat bat
$null = try_alias lzg lazygit
$null = try_alias vi nvim
$null = try_alias vim nvim

if (try_alias ls lsd) {
    function l {
        param()
        lsd -lA @args
    }

    function la {
        param()
        lsd -A @args
    }

    function ll {
        param()
        lsd -la @args
    }

    function lt {
        param()
        lsd --tree @args
    }
}
