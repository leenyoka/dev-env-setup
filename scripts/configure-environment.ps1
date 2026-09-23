[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Configuring developer environment variables..." -ForegroundColor Cyan

[Environment]::SetEnvironmentVariable(
    "DOTNET_CLI_TELEMETRY_OPTOUT",
    "1",
    "User"
)

[Environment]::SetEnvironmentVariable(
    "DOTNET_NOLOGO",
    "true",
    "User"
)

Write-Host "Developer environment variables configured." -ForegroundColor Green