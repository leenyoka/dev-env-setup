[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$scripts = Join-Path $root "scripts"
$config = Join-Path $root "config\dotnet.config"

Write-Host "Installing .NET development environment..." -ForegroundColor Cyan

& (Join-Path $scripts "install-packages.ps1") `
    -ConfigPath $config

& (Join-Path $scripts "configure-dotnet.ps1")

Write-Host ".NET profile complete." -ForegroundColor Green