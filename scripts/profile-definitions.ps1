<#
    Single source of truth for installer profiles.

    install.ps1 uses this for the interactive menu, the -WhatIf summary, and
    picking which profiles/*.ps1 script to run.

    verify-installation.ps1 uses RequiredTools to decide which missing tools
    are a critical failure for the profile that was actually installed,
    versus which are merely informational (not part of that profile).
#>

function Get-ProfileDefinitions {
    [ordered]@{
        Minimal = @{
            Number        = 1
            Menu          = "Minimal"
            DryRun        = "Would install common developer tools."
            ScriptFile    = $null
            RequiredTools = @(
                @{ Name = "git"; DisplayName = "Git" }
                @{ Name = "gh"; DisplayName = "GitHub CLI" }
                @{ Name = "pwsh"; DisplayName = "PowerShell 7" }
                @{ Name = "code"; DisplayName = "VS Code" }
            )
        }

        DotNet = @{
            Number        = 2
            Menu          = ".NET Developer"
            DryRun        = "Would install common + .NET tooling."
            ScriptFile    = "dotnet.ps1"
            RequiredTools = @(
                @{ Name = "dotnet"; DisplayName = ".NET" }
            )
        }

        Frontend = @{
            Number        = 3
            Menu          = "Frontend Developer"
            DryRun        = "Would install common + frontend tooling."
            ScriptFile    = "frontend.ps1"
            RequiredTools = @(
                @{ Name = "node"; DisplayName = "Node.js" }
                @{ Name = "npm"; DisplayName = "npm" }
            )
        }

        Azure = @{
            Number        = 4
            Menu          = "Azure Developer"
            DryRun        = "Would install common + Azure tooling."
            ScriptFile    = "azure.ps1"
            RequiredTools = @(
                @{ Name = "az"; DisplayName = "Azure CLI" }
            )
        }

        Docker = @{
            Number        = 5
            Menu          = "Docker / DevOps"
            DryRun        = "Would install common + Docker tooling."
            ScriptFile    = "docker.ps1"
            RequiredTools = @(
                @{ Name = "docker"; DisplayName = "Docker" }
                @{ Name = "kubectl"; DisplayName = "kubectl" }
                @{ Name = "helm"; DisplayName = "Helm" }
            )
        }

        Database = @{
            Number        = 6
            Menu          = "Database Developer"
            DryRun        = "Would install common + database tooling."
            ScriptFile    = "database.ps1"
            RequiredTools = @(
                @{ Name = "sqlcmd"; DisplayName = "SQLCMD" }
            )
        }

        FullStack = @{
            Number        = 7
            Menu          = "Full Stack"
            DryRun        = "Would install common + .NET + frontend + Azure + Docker + database tooling."
            ScriptFile    = "fullstack.ps1"
            RequiredTools = @(
                @{ Name = "dotnet"; DisplayName = ".NET" }
                @{ Name = "node"; DisplayName = "Node.js" }
                @{ Name = "npm"; DisplayName = "npm" }
                @{ Name = "az"; DisplayName = "Azure CLI" }
                @{ Name = "docker"; DisplayName = "Docker" }
                @{ Name = "kubectl"; DisplayName = "kubectl" }
                @{ Name = "helm"; DisplayName = "Helm" }
                @{ Name = "sqlcmd"; DisplayName = "SQLCMD" }
            )
        }
    }
}
