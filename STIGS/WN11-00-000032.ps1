
 <#
.SYNOPSIS
    This PowerShell script ensures that the BitLocker startup PIN policy is configured with a minimum PIN length of at least 6 digits.

.NOTES
    Author          : Ricardo Moreno
    LinkedIn        : linkedin.com/in/ricardo-moreno-0177762b8
    GitHub          : github.com/RichMorenoIT
    Date Created    : 2024-30-07
    Last Modified   : 2024-30-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000032

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-00-000032.ps1 
#>

# WN11-00-000032
# Configure BitLocker minimum startup PIN length

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"

# Create the key if it does not exist
if (!(Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the minimum PIN length to 6
New-ItemProperty `
    -Path $RegPath `
    -Name "MinimumPIN" `
    -PropertyType DWord `
    -Value 6 `
    -Force | Out-Null

gpupdate /force

Write-Host "WN11-00-000032 remediated successfully." -ForegroundColor Green

reg query "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v MinimumPIN
