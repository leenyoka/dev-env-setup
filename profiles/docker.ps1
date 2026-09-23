[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$scripts = Join-Path $root "scripts"
$config = Join-Path $root "config\docker.config"

Write-Host "Installing Docker / DevOps environment..." -ForegroundColor Cyan

& (Join-Path $scripts "install-packages.ps1") `
    -ConfigPath $config

& (Join-Path $scripts "configure-docker.ps1")

Write-Host "Docker profile complete." -ForegroundColor Green