[CmdletBinding()]
param()

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Environment Verification" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$tools = @(
    @{ Name = "git"; DisplayName = "Git" },
    @{ Name = "gh"; DisplayName = "GitHub CLI" },
    @{ Name = "pwsh"; DisplayName = "PowerShell 7" },
    @{ Name = "dotnet"; DisplayName = ".NET" },
    @{ Name = "node"; DisplayName = "Node.js" },
    @{ Name = "npm"; DisplayName = "npm" },
    @{ Name = "code"; DisplayName = "VS Code" },
    @{ Name = "docker"; DisplayName = "Docker" },
    @{ Name = "az"; DisplayName = "Azure CLI" },
    @{ Name = "kubectl"; DisplayName = "kubectl" },
    @{ Name = "helm"; DisplayName = "Helm" },
    @{ Name = "sqlcmd"; DisplayName = "SQLCMD" },
    @{ Name = "psql"; DisplayName = "PostgreSQL" }
)

$failed = 0

foreach ($tool in $tools) {
    $command = Get-Command $tool.Name -ErrorAction SilentlyContinue

    if ($command) {
        try {
            $version = & $tool.Name --version 2>$null |
                Select-Object -First 1
        }
        catch {
            $version = "installed"
        }

        Write-Host (
            "{0,-20} [OK] {1}" -f $tool.DisplayName, $version
        ) -ForegroundColor Green
    }
    else {
        Write-Host (
            "{0,-20} [--] Not installed" -f $tool.DisplayName
        ) -ForegroundColor Yellow
    }
}

Write-Host ""

if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey          [OK] $((choco --version).Trim())" -ForegroundColor Green
}
else {
    Write-Host "Chocolatey          [FAIL]" -ForegroundColor Red
    $failed++
}

if ($failed -gt 0) {
    Write-Host ""
    Write-Host "Verification completed with $failed critical failure(s)." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Verification completed successfully." -ForegroundColor Green
exit 0