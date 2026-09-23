[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring GitHub CLI..." -ForegroundColor Cyan

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "GitHub CLI is not installed. Skipping." -ForegroundColor Yellow
    exit 0
}

gh config set git_protocol https

Write-Host ""
Write-Host "GitHub CLI is installed." -ForegroundColor Green

$authStatus = gh auth status 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "GitHub CLI is already authenticated." -ForegroundColor Green
}
else {
    Write-Host "GitHub CLI is not authenticated." -ForegroundColor Yellow
    Write-Host "Run 'gh auth login' when you are ready." -ForegroundColor Yellow
}

Write-Host "GitHub configuration complete." -ForegroundColor Green