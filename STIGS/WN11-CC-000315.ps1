<#
.SYNOPSIS
Ensures the Windows Installer policy "Always install with elevated privileges" is disabled.

.DESCRIPTION
This script remediates STIG ID WN11-CC-000315 by:
- Creating the required registry paths if missing
- Disabling AlwaysInstallElevated (HKLM + HKCU)
- Restricting Windows Installer (DisableMSI = 1)

.NOTES
Author          : Ricardo Moreno
LinkedIn        : linkedin.com/in/ricardo-moreno-0177762b8
GitHub          : github.com/RichMorenoIT
Date Created    : 2026-05-05
Last Modified   : 2026-05-05
Version         : 1.1
STIG-ID         : WN11-CC-000315

.TESTED ON
Systems Tested  : Windows 11
PowerShell Ver. : 5.1 / 7.x

.USAGE
Run in an elevated PowerShell session:
PS C:> .\WN11-CC-000315.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

# --- Elevation Check ---

if (-not ([Security.Principal.WindowsPrincipal] `    [Security.Principal.WindowsIdentity]::GetCurrent()`
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
Write-Error "This script must be run as Administrator."
exit 1
}

# --- Paths ---

$HKLMPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$HKCUPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"

function Ensure-RegistryPath {
param (
[string]$Path
)

```
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
    Write-Host "Created: $Path"
}
else {
    Write-Host "Exists: $Path"
}
```

}

function Set-DwordValue {
param (
[string]$Path,
[string]$Name,
[int]$Value
)

```
New-ItemProperty -Path $Path `
    -Name $Name `
    -Value $Value `
    -PropertyType DWord `
    -Force | Out-Null

Write-Host "Set $Name = $Value at $Path"
```

}

try {
# --- Ensure paths exist ---
Ensure-RegistryPath -Path $HKLMPath
Ensure-RegistryPath -Path $HKCUPath

```
# --- Apply STIG settings ---
Set-DwordValue -Path $HKLMPath -Name "AlwaysInstallElevated" -Value 0
Set-DwordValue -Path $HKCUPath -Name "AlwaysInstallElevated" -Value 0
Set-DwordValue -Path $HKLMPath -Name "DisableMSI" -Value 1

# --- Verification ---
$HKLMProps = Get-ItemProperty -Path $HKLMPath
$HKCUProps = Get-ItemProperty -Path $HKCUPath

Write-Host "`nVerification Results:"
Write-Host "HKLM AlwaysInstallElevated =" $HKLMProps.AlwaysInstallElevated
Write-Host "HKCU AlwaysInstallElevated =" $HKCUProps.AlwaysInstallElevated
Write-Host "HKLM DisableMSI =" $HKLMProps.DisableMSI

Write-Host "`nSUCCESS: STIG remediation applied." -ForegroundColor Green
exit 0
```

}
catch {
Write-Error "FAILED: $($_.Exception.Message)"
exit 1
}

