
 <#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Ricardo Moreno
    LinkedIn        : linkedin.com/in/ricardo-moreno-0177762b8
    GitHub          : github.com/RichMorenoIT
    Date Created    : 2026-30-04
    Last Modified   : 2026-30-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-AU-000500.ps1 
#>



# Ensure the registry path exists

 

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"

if (-not (Test-Path $path)) {
New-Item -Path $path -Force | Out-Null
}

  

# Set MaxSize to 0x8000 (32768 in decimal)

New-ItemProperty -Path $path `    -Name "MaxSize"`
-Value 32768 `    -PropertyType DWord`
-Force | Out-Null
