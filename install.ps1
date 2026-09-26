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
$logsPath = Join-Path $scriptRoot "logs"

. (Join-Path $scriptsPath "profile-definitions.ps1")
$profileDefinitions = Get-ProfileDefinitions

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

    $ordered = $profileDefinitions.GetEnumerator() |
        Sort-Object { $_.Value.Number }

    foreach ($entry in $ordered) {
        Write-Host ("  {0}. {1}" -f $entry.Value.Number, $entry.Value.Menu)
    }

    Write-Host ""

    $maxNumber = ($ordered | ForEach-Object { $_.Value.Number } | Measure-Object -Maximum).Maximum

    do {
        $selection = Read-Host "Selection [1-$maxNumber]"

        $match = $ordered | Where-Object { "$($_.Value.Number)" -eq $selection.Trim() }

        if (-not $match) {
            Write-Host "Invalid selection." -ForegroundColor Yellow
        }
    }
    while (-not $match)

    return $match.Key
}

function Test-RequiredFiles {
    $requiredFiles = @(
        "profile-definitions.ps1",
        "install-chocolatey.ps1",
        "install-packages.ps1",
        "configure-windows.ps1",
        "configure-git.ps1",
        "configure-powershell.ps1",
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
    Write-Host $profileDefinitions[$Profile].DryRun
    exit 0
}

# Everything past this point makes real changes and needs elevation.
if (-not (Test-IsAdministrator)) {
    Invoke-Elevated
}

Set-ExecutionPolicy `
    -Scope Process `
    -ExecutionPolicy Bypass `
    -Force

if (-not (Test-Path $logsPath)) {
    New-Item -ItemType Directory -Path $logsPath -Force | Out-Null
}

$logFile = Join-Path $logsPath "setup-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

Start-Transcript -Path $logFile -Append | Out-Null
Write-Host "Logging this run to: $logFile" -ForegroundColor DarkGray

try {
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
    Invoke-Script (Join-Path $scriptsPath "configure-terminal.ps1")
    Invoke-Script (Join-Path $scriptsPath "configure-environment.ps1")
    Invoke-Script (Join-Path $scriptsPath "configure-ssh.ps1")
    Invoke-Script (Join-Path $scriptsPath "configure-github.ps1")

    Write-Host ""
    Write-Host "[5/5] Applying $Profile profile..." -ForegroundColor Cyan

    $scriptFile = $profileDefinitions[$Profile].ScriptFile

    if ($scriptFile) {
        Invoke-Script (Join-Path $profilesPath $scriptFile)
    }
    else {
        Write-Host "Minimal profile complete."
    }

    Write-Host ""
    Write-Host "Verifying installation..." -ForegroundColor Cyan

    Invoke-Script `
        (Join-Path $scriptsPath "verify-installation.ps1") `
        @("-Profile", $Profile)

    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host " Developer environment setup complete!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
}
finally {
    Stop-Transcript | Out-Null
}
