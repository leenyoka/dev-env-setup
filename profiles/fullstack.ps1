[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$profiles = Join-Path $root "profiles"

Write-Host "Installing full-stack development environment..." -ForegroundColor Cyan

& (Join-Path $profiles "dotnet.ps1")
& (Join-Path $profiles "frontend.ps1")
& (Join-Path $profiles "azure.ps1")
& (Join-Path $profiles "docker.ps1")
& (Join-Path $profiles "database.ps1")

Write-Host "Full-stack profile complete." -ForegroundColor Green