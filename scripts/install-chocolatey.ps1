[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Checking Chocolatey..." -ForegroundColor Cyan

if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey is already installed." -ForegroundColor Green
    choco --version
    exit 0
}

Write-Host "Chocolatey is not installed. Installing..." -ForegroundColor Yellow

Set-ExecutionPolicy `
    -Scope Process `
    -ExecutionPolicy Bypass `
    -Force

[System.Net.ServicePointManager]::SecurityProtocol = `
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

$installScript = Invoke-WebRequest `
    -UseBasicParsing `
    -Uri "https://community.chocolatey.org/install.ps1"

Invoke-Expression $installScript.Content

$env:Path = [System.Environment]::GetEnvironmentVariable(
    "Path",
    "Machine"
) + ";" + [System.Environment]::GetEnvironmentVariable(
    "Path",
    "User"
)

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    throw "Chocolatey installation completed but choco was not found on PATH."
}

Write-Host "Chocolatey installed successfully." -ForegroundColor Green
choco --version