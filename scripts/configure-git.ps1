[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring Git..." -ForegroundColor Cyan

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not installed or is not available on PATH."
}

git config --global init.defaultBranch main
git config --global core.autocrlf true
git config --global pull.rebase false
git config --global fetch.prune true
git config --global credential.helper manager

Write-Host "Git configuration complete." -ForegroundColor Green