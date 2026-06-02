
 <#
.SYNOPSIS
    This PowerShell script ensures that the Require Secure RPC Communication for Remote Desktop Session Host.

.NOTES
    Author          : Ricardo Moreno
    LinkedIn        : linkedin.com/in/ricardo-moreno-0177762b8
    GitHub          : github.com/RichMorenoIT
    Date Created    : 2026-01-06
    Last Modified   : 2026-01-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000285

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000285.ps1 
#>



# WN11-CC-000285
# Require Secure RPC Communication for Remote Desktop Session Host

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$ValueName = "fEncryptRPCTraffic"
$DesiredValue = 1

# Create registry path if it does not exist
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Configure STIG setting
New-ItemProperty `
    -Path $RegPath `
    -Name $ValueName `
    -PropertyType DWord `
    -Value $DesiredValue `
    -Force | Out-Null

Write-Host "WN11-CC-000285 remediated successfully."
Write-Host "$ValueName = $DesiredValue"

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

(Get-ItemProperty -Path $RegPath -Name fEncryptRPCTraffic -ErrorAction Stop).fEncryptRPCTraffic
