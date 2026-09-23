[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$scripts = Join-Path $root "scripts"
$config = Join-Path $root "config\database.config"

Write-Host "Installing database development environment..." -ForegroundColor Cyan

& (Join-Path $scripts "install-packages.ps1") `
    -ConfigPath $config

& (Join-Path $scripts "configure-database.ps1")

Write-Host "Database profile complete." -ForegroundColor Green