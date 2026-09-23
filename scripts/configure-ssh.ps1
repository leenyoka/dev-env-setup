[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring SSH..." -ForegroundColor Cyan

$sshDirectory = Join-Path $HOME ".ssh"
$keyPath = Join-Path $sshDirectory "id_ed25519"

if (-not (Test-Path $sshDirectory)) {
    New-Item `
        -ItemType Directory `
        -Path $sshDirectory `
        -Force | Out-Null
}

if (Test-Path $keyPath) {
    Write-Host "Existing SSH key found. Leaving it unchanged." -ForegroundColor Yellow
}
else {
    Write-Host "No SSH key found." -ForegroundColor Yellow
    Write-Host "SSH key generation has been skipped." -ForegroundColor Yellow
    Write-Host "Use 'ssh-keygen -t ed25519' if you want to create one."
}

Write-Host "SSH configuration complete." -ForegroundColor Green