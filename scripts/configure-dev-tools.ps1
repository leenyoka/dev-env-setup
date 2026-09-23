[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Checking developer tools..." -ForegroundColor Cyan

function Test-Command {
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    return $null -ne (
        Get-Command $Name -ErrorAction SilentlyContinue
    )
}

$tools = @(
    @{ Name = "git"; DisplayName = "Git" },
    @{ Name = "gh"; DisplayName = "GitHub CLI" },
    @{ Name = "dotnet"; DisplayName = ".NET" },
    @{ Name = "node"; DisplayName = "Node.js" },
    @{ Name = "npm"; DisplayName = "npm" },
    @{ Name = "code"; DisplayName = "Visual Studio Code" },
    @{ Name = "docker"; DisplayName = "Docker" }
)

foreach ($tool in $tools) {
    if (Test-Command $tool.Name) {
        Write-Host "$($tool.DisplayName): installed" -ForegroundColor Green
    }
    else {
        Write-Host "$($tool.DisplayName): not installed" -ForegroundColor Yellow
    }
}

if (Test-Command "gh") {
    gh config set git_protocol https
}

Write-Host "Developer tools check complete." -ForegroundColor Green