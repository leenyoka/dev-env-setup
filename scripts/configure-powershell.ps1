[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring PowerShell..." -ForegroundColor Cyan

$profileDirectory = Split-Path -Parent $PROFILE

if (-not (Test-Path $profileDirectory)) {
    New-Item `
        -ItemType Directory `
        -Path $profileDirectory `
        -Force | Out-Null
}

if (-not (Test-Path $PROFILE)) {
    @'
# Developer environment profile

Set-Alias ll Get-ChildItem
Set-Alias which Get-Command

$env:DOTNET_CLI_TELEMETRY_OPTOUT = "1"
'@ | Set-Content `
        -Path $PROFILE `
        -Encoding UTF8

    Write-Host "Created PowerShell profile." -ForegroundColor Green
}
else {
    Write-Host "Existing PowerShell profile preserved." -ForegroundColor Yellow
}

Write-Host "PowerShell configuration complete." -ForegroundColor Green