#Requires -RunAsAdministrator
<#
.SYNOPSIS
    NALB Image Resizer - Install Prerequisites
.DESCRIPTION
    Installs Docker Desktop and Git on Windows 10/11
    Right-click -> Run with PowerShell (as Administrator)
#>

Write-Host ""
Write-Host "===================================" -ForegroundColor Cyan
Write-Host "  NALB Image Resizer - Installer"   -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# --- Check winget ---
$wingetAvailable = $false
try {
    $null = Get-Command winget -ErrorAction Stop
    $wingetAvailable = $true
} catch {
    Write-Host "[!] winget not found." -ForegroundColor Yellow
    Write-Host "    Install 'App Installer' from the Microsoft Store:" -ForegroundColor Yellow
    Write-Host "    https://apps.microsoft.com/detail/9NBLGGH4NNS1" -ForegroundColor Yellow
    Write-Host ""
}

# --- Install Git ---
Write-Host "[1/4] Checking Git..." -ForegroundColor White
$gitInstalled = $null -ne (Get-Command git -ErrorAction SilentlyContinue)

if ($gitInstalled) {
    $gitVersion = git --version
    Write-Host "      Already installed: $gitVersion" -ForegroundColor Green
} elseif ($wingetAvailable) {
    Write-Host "      Installing Git..." -ForegroundColor Yellow
    winget install --id Git.Git --accept-source-agreements --accept-package-agreements --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "      Git installed successfully." -ForegroundColor Green
    } else {
        Write-Host "      Git install failed. Download manually: https://git-scm.com/download/win" -ForegroundColor Red
    }
} else {
    Write-Host "      Skipped (winget not available). Download manually: https://git-scm.com/download/win" -ForegroundColor Red
}

# --- Install Docker Desktop ---
Write-Host ""
Write-Host "[2/4] Checking Docker Desktop..." -ForegroundColor White
$dockerInstalled = $null -ne (Get-Command docker -ErrorAction SilentlyContinue)

if ($dockerInstalled) {
    $dockerVersion = docker --version
    Write-Host "      Already installed: $dockerVersion" -ForegroundColor Green
} elseif ($wingetAvailable) {
    Write-Host "      Installing Docker Desktop (this may take a few minutes)..." -ForegroundColor Yellow
    winget install --id Docker.DockerDesktop --accept-source-agreements --accept-package-agreements --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "      Docker Desktop installed successfully." -ForegroundColor Green
    } else {
        Write-Host "      Docker install failed. Download manually: https://www.docker.com/products/docker-desktop" -ForegroundColor Red
    }
} else {
    Write-Host "      Skipped (winget not available). Download manually: https://www.docker.com/products/docker-desktop" -ForegroundColor Red
}

# --- Enable Windows features for Docker ---
Write-Host ""
Write-Host "[3/4] Enabling Windows features for Docker..." -ForegroundColor White

$wslState = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State
if ($wslState -ne "Enabled") {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart | Out-Null
    Write-Host "      WSL enabled." -ForegroundColor Green
} else {
    Write-Host "      WSL already enabled." -ForegroundColor Green
}

$vmState = (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State
if ($vmState -ne "Enabled") {
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart | Out-Null
    Write-Host "      Virtual Machine Platform enabled." -ForegroundColor Green
} else {
    Write-Host "      Virtual Machine Platform already enabled." -ForegroundColor Green
}

# --- Verify ---
Write-Host ""
Write-Host "[4/4] Verifying installation..." -ForegroundColor White
Write-Host ""

# Refresh PATH so newly installed tools are found
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

$needRestart = $false

$gitCheck = Get-Command git -ErrorAction SilentlyContinue
if ($gitCheck) {
    $v = git --version
    Write-Host "      [OK] $v" -ForegroundColor Green
} else {
    Write-Host "      [!!] Git not found - a restart may be needed" -ForegroundColor Yellow
    $needRestart = $true
}

$dockerCheck = Get-Command docker -ErrorAction SilentlyContinue
if ($dockerCheck) {
    $v = docker --version
    Write-Host "      [OK] $v" -ForegroundColor Green
} else {
    Write-Host "      [!!] Docker not found - a restart is needed" -ForegroundColor Yellow
    $needRestart = $true
}

Write-Host ""
Write-Host "===================================" -ForegroundColor Cyan

if ($needRestart) {
    Write-Host ""
    Write-Host "  A restart is required to finish setup." -ForegroundColor Yellow
    Write-Host ""
    $answer = Read-Host "  Restart now? (y/n)"
    if ($answer -eq "y") {
        Restart-Computer -Force
    }
} else {
    Write-Host ""
    Write-Host "  Everything is installed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor White
    Write-Host "    1. Open Docker Desktop and let it finish starting" -ForegroundColor White
    Write-Host "    2. Double-click start.bat to run the Image Resizer" -ForegroundColor White
    Write-Host ""
}

Read-Host "Press Enter to close"
