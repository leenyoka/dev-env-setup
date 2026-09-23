[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring .NET..." -ForegroundColor Cyan

if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    throw ".NET SDK is not installed."
}

dotnet --info

$tools = @(
    "dotnet-ef",
    "dotnet-format"
)

foreach ($tool in $tools) {
    $installed = dotnet tool list --global |
        Select-String -SimpleMatch $tool

    if ($installed) {
        Write-Host "$tool already installed." -ForegroundColor Yellow
    }
    else {
        Write-Host "Installing $tool..." -ForegroundColor Cyan

        dotnet tool install --global $tool

        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install .NET tool: $tool"
        }
    }
}

[Environment]::SetEnvironmentVariable(
    "DOTNET_CLI_TELEMETRY_OPTOUT",
    "1",
    "User"
)

Write-Host ".NET configuration complete." -ForegroundColor Green