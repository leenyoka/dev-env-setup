[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$scripts = Join-Path $root "scripts"
$config = Join-Path $root "config\azure.config"

Write-Host "Installing Azure development environment..." -ForegroundColor Cyan

& (Join-Path $scripts "install-packages.ps1") `
    -ConfigPath $config

& (Join-Path $scripts "configure-azure.ps1")

Write-Host "Azure profile complete." -ForegroundColor Green