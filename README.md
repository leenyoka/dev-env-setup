# Developer Environment Setup

A modular Windows developer-environment bootstrapper that installs and configures common development tools using **PowerShell** and **Chocolatey**.

The project is designed around a single entry point:

```powershell
.\install.ps1
```

Developers can either select a development profile interactively or specify one through command-line parameters.

---

## Features

* Single-command developer environment setup
* Automatic Administrator elevation
* Handles PowerShell execution-policy restrictions
* Installs Chocolatey automatically when required
* Installs common development tools
* Profile-based installation
* .NET development setup
* Frontend/Node.js setup
* Azure development setup
* Docker/DevOps setup
* Database tooling
* Git configuration
* GitHub CLI configuration
* SSH environment setup
* PowerShell configuration
* Windows Terminal detection
* Developer environment variables
* Installation verification
* Non-interactive mode
* Dry-run mode

---

## Requirements

The machine must be running:

* Windows 10 or later
* PowerShell 5.1 or later
* Internet access
* Administrator access

The installer automatically handles the installation of Chocolatey.

---

## Project Structure

```text
dev-env-setup/
│
├── install.ps1
│
├── config/
│   ├── packages.config
│   ├── dotnet.config
│   ├── frontend.config
│   ├── azure.config
│   ├── docker.config
│   └── database.config
│
├── profiles/
│   ├── dotnet.ps1
│   ├── frontend.ps1
│   ├── azure.ps1
│   ├── docker.ps1
│   ├── database.ps1
│   └── fullstack.ps1
│
└── scripts/
    ├── install-chocolatey.ps1
    ├── install-packages.ps1
    ├── configure-windows.ps1
    ├── configure-git.ps1
    ├── configure-powershell.ps1
    ├── configure-dev-tools.ps1
    ├── configure-dotnet.ps1
    ├── configure-node.ps1
    ├── configure-azure.ps1
    ├── configure-docker.ps1
    ├── configure-database.ps1
    ├── configure-ssh.ps1
    ├── configure-github.ps1
    ├── configure-terminal.ps1
    ├── configure-environment.ps1
    └── verify-installation.ps1
```

---

# Quick Start

Clone the repository and enter the directory:

```powershell
git clone <repository-url>
cd dev-env-setup
```

Run the installer:

```powershell
.\install.ps1
```

If Administrator privileges are required, Windows will request elevation automatically.

---

# Development Profiles

The installer supports several profiles.

| Profile     | Purpose                          |
| ----------- | -------------------------------- |
| `Minimal`   | Basic developer environment      |
| `DotNet`    | .NET development                 |
| `Frontend`  | Node.js/frontend development     |
| `Azure`     | Azure development                |
| `Docker`    | Docker and DevOps tooling        |
| `Database`  | Database development             |
| `FullStack` | Complete development environment |

---

## Minimal

Installs the common developer environment:

* Git
* GitHub CLI
* PowerShell 7
* Windows Terminal
* Visual Studio Code
* 7-Zip
* Notepad++

Run:

```powershell
.\install.ps1 -Profile Minimal
```

---

# .NET Developer

The `.NET` profile installs the common tools plus .NET development tooling.

Includes:

* .NET SDK
* .NET runtime
* Entity Framework CLI
* `dotnet-format`

Run:

```powershell
.\install.ps1 -Profile DotNet
```

Useful .NET commands after installation:

```powershell
dotnet --info
dotnet ef --version
dotnet format --version
```

---

# Frontend Developer

The frontend profile installs:

* Node.js LTS
* npm
* Corepack
* Visual Studio Code
* Git

Run:

```powershell
.\install.ps1 -Profile Frontend
```

Verify:

```powershell
node --version
npm --version
```

---

# Azure Developer

The Azure profile installs:

* Azure CLI
* Azure Functions Core Tools
* Bicep

Run:

```powershell
.\install.ps1 -Profile Azure
```

Verify:

```powershell
az version
func --version
bicep --version
```

Azure authentication is intentionally **not performed automatically**.

Authenticate manually when required:

```powershell
az login
```

---

# Docker / DevOps

The Docker profile installs:

* Docker Desktop
* Docker Compose
* kubectl
* Helm

Run:

```powershell
.\install.ps1 -Profile Docker
```

Verify:

```powershell
docker --version
docker compose version
kubectl version --client
helm version
```

Docker Desktop may require a restart or additional Windows/WSL configuration.

---

# Database Developer

The database profile installs database development tools such as:

* SQL Server Management Studio
* SQLCMD
* DBeaver

Run:

```powershell
.\install.ps1 -Profile Database
```

The database profile is intended primarily for development tooling. It does not automatically create databases, users, passwords, or project-specific database configuration.

---

# Full Stack

The Full Stack profile combines:

* .NET
* Frontend
* Azure
* Docker
* Database tooling

Run:

```powershell
.\install.ps1 -Profile FullStack
```

This is the most complete developer environment.

---

# Interactive Installation

If no profile is specified:

```powershell
.\install.ps1
```

The installer displays:

```text
Select development profile:

  1. Minimal
  2. .NET Developer
  3. Frontend Developer
  4. Azure Developer
  5. Docker / DevOps
  6. Database Developer
  7. Full Stack

Selection [1-7]:
```

---

# Non-Interactive Installation

For automated provisioning:

```powershell
.\install.ps1 -Profile FullStack -NonInteractive
```

This is useful for:

* New developer machines
* Machine provisioning
* IT setup
* Automated Windows deployments
* Rebuilding development environments

When `-NonInteractive` is used without a profile, `Minimal` is selected.

---

# Dry Run

Use `-WhatIf` to see what profile would be installed without making changes:

```powershell
.\install.ps1 -Profile FullStack -WhatIf
```

Example:

```text
DRY RUN - no changes will be made.

Would install common + .NET + frontend + Azure + Docker + database tooling.
```

---

# Chocolatey

Chocolatey is automatically installed if it is not already available.

The installer checks:

```powershell
Get-Command choco
```

If Chocolatey is already installed, the existing installation is preserved.

Package definitions are stored in:

```text
config/
```

For example:

```text
config/packages.config
config/dotnet.config
config/frontend.config
```

Packages can be added or removed from these files without changing the PowerShell installation logic.

Comments can be added using `#`:

```text
# Common developer tools
git
gh
vscode
```

---

# Git Configuration

The setup configures common Git defaults:

```text
init.defaultBranch = main
core.autocrlf = true
pull.rebase = false
fetch.prune = true
credential.helper = manager
```

Existing Git repositories are not modified.

---

# GitHub CLI

GitHub CLI is installed as part of the common developer environment.

Check authentication:

```powershell
gh auth status
```

If authentication is required:

```powershell
gh auth login
```

Authentication is deliberately interactive so credentials are never stored in this repository or embedded in scripts.

---

# SSH

The setup checks for an existing SSH configuration.

Existing keys are **never overwritten**.

If no key exists, the installer does not automatically generate one.

You can create an Ed25519 key manually:

```powershell
ssh-keygen -t ed25519
```

---

# PowerShell

The installer creates a PowerShell profile if one does not already exist.

It adds useful developer conveniences such as:

```powershell
ll
which
```

Existing PowerShell profiles are preserved.

---

# Environment Variables

The setup configures common developer environment variables:

```text
DOTNET_CLI_TELEMETRY_OPTOUT=1
DOTNET_NOLOGO=true
```

Project-specific secrets are **not** configured by this project.

Do not add secrets such as:

```text
API_KEY
PASSWORD
CLIENT_SECRET
JWT_SECRET
DATABASE_PASSWORD
```

to the repository or configuration files.

---

# Verification

At the end of the installation, the setup runs:

```text
scripts/verify-installation.ps1
```

It checks for tools such as:

```text
Git
GitHub CLI
PowerShell
.NET
Node.js
npm
VS Code
Docker
Azure CLI
kubectl
Helm
SQLCMD
PostgreSQL
Chocolatey
```

Example:

```text
============================================
 Environment Verification
============================================

Git                  [OK]
GitHub CLI           [OK]
PowerShell 7         [OK]
.NET                 [OK]
Node.js              [OK]
npm                  [OK]
VS Code              [OK]
Docker               [OK]
Azure CLI            [OK]
```

---

# Re-running the Installer

The installer is designed to be run more than once.

For example:

```powershell
.\install.ps1 -Profile DotNet
```

can be run again after the machine has already been configured.

Existing installations are generally detected and preserved by Chocolatey and the configuration scripts.

Existing:

* Git configuration
* PowerShell profile
* SSH keys
* GitHub authentication

are not intentionally overwritten.

---

# Execution Policy

The installer uses a **process-scoped** execution-policy bypass when it starts:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

This allows the bootstrap process to run without requiring the user to permanently disable PowerShell security controls.

The Windows configuration step may set the current user's policy to:

```text
RemoteSigned
```

if the current user policy is `Restricted` or `Undefined`.

Machine-wide execution policies are not changed.

---

# Administrator Access

Some operations require Administrator privileges, including:

* Chocolatey installation
* System-level package installation
* Windows registry configuration
* Long-path configuration

If the installer is not running as Administrator, it automatically requests elevation through Windows UAC.

---

# Customising the Environment

The project is intentionally configuration-driven.

To add a common package, edit:

```text
config/packages.config
```

To add a .NET-specific package:

```text
config/dotnet.config
```

For frontend tooling:

```text
config/frontend.config
```

For Azure:

```text
config/azure.config
```

For Docker:

```text
config/docker.config
```

For databases:

```text
config/database.config
```

This allows the installation logic to remain unchanged while the actual development environment evolves.

---

# Recommended Usage

For a new .NET/Azure developer:

```powershell
.\install.ps1 -Profile DotNet
```

For a frontend developer:

```powershell
.\install.ps1 -Profile Frontend
```

For a developer working across the entire stack:

```powershell
.\install.ps1 -Profile FullStack
```

For automated provisioning:

```powershell
.\install.ps1 -Profile FullStack -NonInteractive
```

Before making changes:

```powershell
.\install.ps1 -Profile FullStack -WhatIf
```

---

# Design Goals

The project aims to be:

* **Repeatable** — a developer can rebuild their environment.
* **Modular** — install only what is required.
* **Idempotent** — running the setup again should not unnecessarily break existing configuration.
* **Safe** — don't overwrite credentials, SSH keys, or existing profiles.
* **Configurable** — package lists are separate from installation logic.
* **Automatable** — support non-interactive provisioning.
* **Verifiable** — report what was successfully installed.
* **Maintainable** — individual tools can be updated without rewriting the entire bootstrapper.

---

# Future Improvements

Potential future additions include:

* Version-specific .NET SDK installation
* Node.js version selection
* Angular/React/Vue profiles
* Visual Studio installation
* VS Code extension profiles
* WSL2 setup
* Windows feature management
* SQL Server Developer installation
* PostgreSQL profile
* Redis profile
* Terraform
* AWS CLI
* GCP CLI
* Kubernetes development environments
* `kind`
* Minikube
* Helm
* Terraform
* project-specific templates
* JSON/YAML configuration
* environment snapshots
* export/import of developer configurations
* automatic detection of installed tools and versions
* update mode
* uninstall/cleanup mode

---

## License

Add the project's chosen license here.

If this repository is intended for personal use only, this section can be removed.
