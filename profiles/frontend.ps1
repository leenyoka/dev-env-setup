[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$scripts = Join-Path $root "scripts"
$config = Join-Path $root "config\frontend.config"

Write-Host "Installing frontend development environment..." -ForegroundColor Cyan

& (Join-Path $scripts "install-packages.ps1") `
    -ConfigPath $config

& (Join-Path $scripts "configure-node.ps1")

Write-Host "Frontend profile complete." -ForegroundColor Green