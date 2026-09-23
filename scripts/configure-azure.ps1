[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring Azure tooling..." -ForegroundColor Cyan

if (Get-Command az -ErrorAction SilentlyContinue) {
    Write-Host "Azure CLI:" -ForegroundColor Green
    az version
}
else {
    Write-Host "Azure CLI not found." -ForegroundColor Yellow
}

if (Get-Command func -ErrorAction SilentlyContinue) {
    Write-Host "Azure Functions Core Tools:" -ForegroundColor Green
    func --version
}
else {
    Write-Host "Azure Functions Core Tools not found." -ForegroundColor Yellow
}

if (Get-Command bicep -ErrorAction SilentlyContinue) {
    Write-Host "Bicep:" -ForegroundColor Green
    bicep --version
}
else {
    Write-Host "Bicep not found." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Azure authentication is not performed automatically." -ForegroundColor Yellow
Write-Host "Run 'az login' when you are ready." -ForegroundColor Yellow

Write-Host "Azure configuration complete." -ForegroundColor Green