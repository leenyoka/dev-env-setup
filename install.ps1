[CmdletBinding()]
param(
    [ValidateSet(
        "Minimal",
        "DotNet",
        "Frontend",
        "Azure",
        "Docker",
        "Database",
        "FullStack"
    )]
    [string] $Profile,

    [switch] $NonInteractive,

    [switch] $WhatIf
)

$ErrorActionPreference = "Stop"

$scriptRoot = $PSScriptRoot
$scriptsPath = Join-Path $scriptRoot "scripts"
$profilesPath = Join-Path $scriptRoot "profiles"

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)

    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Invoke-Elevated {
    Write-Host "Administrator privileges are required." -ForegroundColor Yellow
    Write-Host "Requesting elevation..." -ForegroundColor Cyan

    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""

    if ($Profile) {
        $arguments += " -Profile $Profile"
    }

    if ($NonInteractive) {
        $arguments += " -NonInteractive"
    }

    if ($WhatIf) {
        $arguments += " -WhatIf"
    }

    Start-Process `
        -FilePath "powershell.exe" `
        -ArgumentList $arguments `
        -Verb RunAs

    exit 0
}

function Select-Profile {
    Write-Host ""
    Write-Host "Select development profile:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. Minimal"
    Write-Host "  2. .NET Developer"
    Write-Host "  3. Frontend Developer"
    Write-Host "  4. Azure Developer"
    Write-Host "  5. Docker / DevOps"
    Write-Host "  6. Database Developer"
    Write-Host "  7. Full Stack"
    Write-Host ""

    do {
        $selection = Read-Host "Selection [1-7]"

        $Profile = switch ($selection) {
            "1" { "Minimal" }
            "2" { "DotNet" }
            "3" { "Frontend" }
            "4" { "Azure" }
            "5" { "Docker" }
            "6" { "Database" }
            "7" { "FullStack" }
            default { $null }
        }

        if (-not $Profile) {
            Write-Host "Invalid selection." -ForegroundColor Yellow
        }
    }
    while (-not $Profile)

    return $Profile
}

function Test-RequiredFiles {
    $requiredFiles = @(
        "install-chocolatey.ps1",
        "install-packages.ps1",
        "configure-windows.ps1",
        "configure-git.ps1",
        "configure-powershell.ps1",
        "configure-dev-tools.ps1",
        "configure-dotnet.ps1",
        "configure-node.ps1",
        "configure-azure.ps1",
        "configure-docker.ps1",
        "configure-database.ps1",
        "configure-ssh.ps1",
        "configure-github.ps1",
        "configure-terminal.ps1",
        "configure-environment.ps1",
        "verify-installation.ps1"
    )

    foreach ($file in $requiredFiles) {
        $path = Join-Path $scriptsPath $file

        if (-not (Test-Path $path)) {
            throw "Required script not found: $path"
        }
    }
}

function Invoke-Script {
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [string[]] $Arguments = @()
    )

    if (-not (Test-Path $Path)) {
        throw "Script not found: $Path"
    }

    & $Path @Arguments

    if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
        throw "Script failed: $Path"
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "     Windows Developer Environment Setup" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-IsAdministrator)) {
    Invoke-Elevated
}

Set-ExecutionPolicy `
    -Scope Process `
    -ExecutionPolicy Bypass `
    -Force

Test-RequiredFiles

if (-not $Profile) {
    if ($NonInteractive) {
        $Profile = "Minimal"
    }
    else {
        $Profile = Select-Profile
    }
}

Write-Host ""
Write-Host "Selected profile: $Profile" -ForegroundColor Green

if ($WhatIf) {
    Write-Host ""
    Write-Host "DRY RUN - no changes will be made." -ForegroundColor Yellow
    Write-Host ""

    switch ($Profile) {
        "Minimal" {
            Write-Host "Would install common developer tools."
        }

        "DotNet" {
            Write-Host "Would install common + .NET tooling."
        }

        "Frontend" {
            Write-Host "Would install common + frontend tooling."
        }

        "Azure" {
            Write-Host "Would install common + Azure tooling."
        }

        "Docker" {
            Write-Host "Would install common + Docker tooling."
        }

        "Database" {
            Write-Host "Would install common + database tooling."
        }

        "FullStack" {
            Write-Host "Would install common + .NET + frontend + Azure + Docker + database tooling."
        }
    }

    exit 0
}

Write-Host ""
Write-Host "[1/5] Installing Chocolatey..." -ForegroundColor Cyan
Invoke-Script (Join-Path $scriptsPath "install-chocolatey.ps1")

Write-Host ""
Write-Host "[2/5] Installing common packages..." -ForegroundColor Cyan
Invoke-Script `
    (Join-Path $scriptsPath "install-packages.ps1") `
    @("-ConfigPath", (Join-Path $scriptRoot "config\packages.config"))

Write-Host ""
Write-Host "[3/5] Configuring Windows..." -ForegroundColor Cyan
Invoke-Script (Join-Path $scriptsPath "configure-windows.ps1")

Write-Host ""
Write-Host "[4/5] Configuring developer environment..." -ForegroundColor Cyan

Invoke-Script (Join-Path $scriptsPath "configure-git.ps1")
Invoke-Script (Join-Path $scriptsPath "configure-powershell.ps1")
Invoke-Script (Join-Path $scriptsPath "configure-dev-tools.ps1")
Invoke-Script (Join-Path $scriptsPath "configure-terminal.ps1")
Invoke-Script (Join-Path $scriptsPath "configure-environment.ps1")
Invoke-Script (Join-Path $scriptsPath "configure-ssh.ps1")
Invoke-Script (Join-Path $scriptsPath "configure-github.ps1")

Write-Host ""
Write-Host "[5/5] Applying $Profile profile..." -ForegroundColor Cyan

switch ($Profile) {
    "Minimal" {
        Write-Host "Minimal profile complete."
    }

    "DotNet" {
        Invoke-Script (Join-Path $profilesPath "dotnet.ps1")
    }

    "Frontend" {
        Invoke-Script (Join-Path $profilesPath "frontend.ps1")
    }

    "Azure" {
        Invoke-Script (Join-Path $profilesPath "azure.ps1")
    }

    "Docker" {
        Invoke-Script (Join-Path $profilesPath "docker.ps1")
    }

    "Database" {
        Invoke-Script (Join-Path $profilesPath "database.ps1")
    }

    "FullStack" {
        Invoke-Script (Join-Path $profilesPath "fullstack.ps1")
    }
}

Write-Host ""
Write-Host "Verifying installation..." -ForegroundColor Cyan

Invoke-Script (Join-Path $scriptsPath "verify-installation.ps1")

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host " Developer environment setup complete!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""