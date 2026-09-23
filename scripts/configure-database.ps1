[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Checking database tools..." -ForegroundColor Cyan

$tools = @(
    @{ Name = "sqlcmd"; DisplayName = "SQLCMD" },
    @{ Name = "psql"; DisplayName = "PostgreSQL" }
)

foreach ($tool in $tools) {
    if (Get-Command $tool.Name -ErrorAction SilentlyContinue) {
        Write-Host "$($tool.DisplayName): installed" -ForegroundColor Green
    }
    else {
        Write-Host "$($tool.DisplayName): not installed" -ForegroundColor Yellow
    }
}

Write-Host "Database configuration complete." -ForegroundColor Green