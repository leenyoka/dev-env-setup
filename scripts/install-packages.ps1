[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $ConfigPath
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $ConfigPath)) {
    throw "Package configuration not found: $ConfigPath"
}

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    throw "Chocolatey is not installed."
}

$packages = Get-Content $ConfigPath |
    Where-Object {
        $_.Trim() -and
        -not $_.Trim().StartsWith("#")
    } |
    ForEach-Object {
        $_.Trim()
    }

foreach ($package in $packages) {
    Write-Host ""
    Write-Host "Installing $package..." -ForegroundColor Cyan

    choco install $package `
        --yes `
        --no-progress `
        --limit-output

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install Chocolatey package: $package"
    }
}

Write-Host ""
Write-Host "Package installation complete." -ForegroundColor Green