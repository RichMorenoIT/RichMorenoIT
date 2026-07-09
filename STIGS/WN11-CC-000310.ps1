
 <#
.SYNOPSIS
    This PowerShell script ensures only administrators can change installation options, preventing users from bypassing security features

.NOTES
    Author          : Ricardo Moreno
    LinkedIn        : linkedin.com/in/ricardo-moreno-0177762b8
    GitHub          : github.com/RichMorenoIT
    Date Created    : 2026-08-07
    Last Modified   : 2026-08-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 
    
# STIG ID: WN11-CC-000310
# Prevent users from changing installation options

<#

# STIG ID: WN11-CC-000310
# Prevent users from changing installation options

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"

# Create registry path if it doesn't exist
if (!(Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Configure the required STIG value
New-ItemProperty `
    -Path $RegPath `
    -Name "EnableUserControl" `
    -PropertyType DWord `
    -Value 0 `
    -Force | Out-Null

Write-Host "WN11-CC-000310 remediation applied successfully."

# Display current setting for verification
Get-ItemProperty -Path $RegPath | Select-Object EnableUserControl

