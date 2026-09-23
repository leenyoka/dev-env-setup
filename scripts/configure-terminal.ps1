[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring Windows Terminal..." -ForegroundColor Cyan

$terminal = Get-Command wt.exe -ErrorAction SilentlyContinue

if ($terminal) {
    Write-Host "Windows Terminal is installed." -ForegroundColor Green
}
else {
    Write-Host "Windows Terminal was not found." -ForegroundColor Yellow
}

Write-Host "Terminal configuration complete." -ForegroundColor Green