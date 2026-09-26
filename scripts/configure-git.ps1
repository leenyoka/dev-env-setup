[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring Git..." -ForegroundColor Cyan

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not installed or is not available on PATH."
}

function Set-GitDefault {
    param(
        [Parameter(Mandatory)] [string] $Key,
        [Parameter(Mandatory)] [string] $Value
    )

    $existing = git config --global --get $Key 2>$null

    if ($LASTEXITCODE -eq 0 -and $existing) {
        Write-Host "$Key already set to '$existing' - leaving unchanged." -ForegroundColor Yellow
        return
    }

    git config --global $Key $Value
    Write-Host "$Key set to '$Value'." -ForegroundColor Green
}

Set-GitDefault -Key "init.defaultBranch" -Value "main"
Set-GitDefault -Key "core.autocrlf" -Value "true"
Set-GitDefault -Key "pull.rebase" -Value "false"
Set-GitDefault -Key "fetch.prune" -Value "true"
Set-GitDefault -Key "credential.helper" -Value "manager"

Write-Host "Git configuration complete." -ForegroundColor Green
