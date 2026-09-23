[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring Node.js..." -ForegroundColor Cyan

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js is not installed."
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "npm is not installed."
}

Write-Host "Node.js version:"
node --version

Write-Host "npm version:"
npm --version

if (Get-Command corepack -ErrorAction SilentlyContinue) {
    corepack enable
    Write-Host "Corepack enabled." -ForegroundColor Green
}

Write-Host "Node.js configuration complete." -ForegroundColor Green