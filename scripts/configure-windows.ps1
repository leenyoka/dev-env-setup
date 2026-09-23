[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring Windows developer settings..." -ForegroundColor Cyan

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $isAdmin) {
    throw "This script must be run as Administrator."
}

$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser

if ($currentPolicy -eq "Undefined" -or $currentPolicy -eq "Restricted") {
    Set-ExecutionPolicy `
        -Scope CurrentUser `
        -ExecutionPolicy RemoteSigned `
        -Force

    Write-Host "Set CurrentUser execution policy to RemoteSigned." -ForegroundColor Green
}

$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"

Set-ItemProperty `
    -Path $registryPath `
    -Name "LongPathsEnabled" `
    -Value 1 `
    -Type DWord

Write-Host "Long paths enabled." -ForegroundColor Green

Write-Host "Windows configuration complete." -ForegroundColor Green