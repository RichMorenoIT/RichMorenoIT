
 <#
.SYNOPSIS
    This PowerShell script ensures that the Windows Remote Management (WinRM) service must not use Basic authentication..

.NOTES
    Author          : Ricardo Moreno
    LinkedIn        : linkedin.com/in/ricardo-moreno-0177762b8
    GitHub          : github.com/RichMorenoIT
    Date Created    : 2026-08-06
    Last Modified   : 2026-08-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000345

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000345.ps1 

#>

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
$ValueName = "AllowBasic"
$DesiredValue = 0

# Create registry path if it does not exist
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set required STIG value
New-ItemProperty `
    -Path $RegPath `
    -Name $ValueName `
    -PropertyType DWord `
    -Value $DesiredValue `
    -Force | Out-Null

# Apply to current WinRM configuration
try {
    Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $false -Force
}
catch {
    Write-Warning "Unable to update live WSMan configuration. A GP refresh may be required."
}

# Restart WinRM
Restart-Service WinRM -Force

Write-Host "WN11-CC-000345 remediated successfully."
Write-Host "$ValueName = $DesiredValue"
