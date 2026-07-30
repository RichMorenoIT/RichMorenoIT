
 <#
.SYNOPSIS
    This PowerShell script ensures that RDP's client connection encryption level to High.

.NOTES
    Author          : Ricardo Moreno
    LinkedIn        : linkedin.com/in/ricardo-moreno-0177762b8
    GitHub          : github.com/RichMorenoIT
    Date Created    : 2026-29-07
    Last Modified   : 2026-29-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000290

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000290.ps1 
#>



# WN11-CC-000290 Remediation
# Configure RDP client connection encryption level to High

$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

# Create the registry path if it doesn't exist
New-Item -Path $Path -Force | Out-Null

# Set encryption level to High (3)
New-ItemProperty `
    -Path $Path `
    -Name "MinEncryptionLevel" `
    -PropertyType DWord `
    -Value 3 `
    -Force | Out-Null

# Refresh Group Policy
gpupdate /force

Write-Host "WN11-CC-000290 remediated successfully." -ForegroundColor Green

Get-ItemProperty `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" `
    -Name MinEncryptionLevel
