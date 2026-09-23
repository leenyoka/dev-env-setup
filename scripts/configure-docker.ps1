[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring Docker..." -ForegroundColor Cyan

if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "Docker:" -ForegroundColor Green
    docker --version
}
else {
    Write-Host "Docker is not available on PATH." -ForegroundColor Yellow
}

if (Get-Command docker-compose -ErrorAction SilentlyContinue) {
    docker-compose version
}
elseif (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "Docker Compose:" -ForegroundColor Green
    docker compose version
}

if (Get-Command kubectl -ErrorAction SilentlyContinue) {
    Write-Host "kubectl:" -ForegroundColor Green
    kubectl version --client
}

if (Get-Command helm -ErrorAction SilentlyContinue) {
    Write-Host "Helm:" -ForegroundColor Green
    helm version
}

Write-Host "Docker configuration complete." -ForegroundColor Green