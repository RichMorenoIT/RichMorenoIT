
 <#
.SYNOPSIS
    This PowerShell script ensures Windows 11 systems must use a BitLocker PIN for pre-boot authentication.

.NOTES
    Author          : Ricardo Moreno
    LinkedIn        : linkedin.com/in/ricardo-moreno-0177762b8
    GitHub          : github.com/RichMorenoIT
    Date Created    : 2024-23-05
    Last Modified   : 2024-23-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000031

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-00-000031.ps1 
#>



# Ensure the registry path exists

 

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"

# Create registry path if missing
if (!(Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Explicitly create/set required values
$RegistrySettings = @{
    "UseAdvancedStartup" = 1
    "UseTPM"             = 2
    "UseTPMPIN"          = 2
    "UseTPMKey"          = 0
    "UseTPMKeyPIN"       = 0
    "MinimumPIN"         = 6
}

foreach ($Name in $RegistrySettings.Keys) {

    if (Get-ItemProperty -Path $RegPath -Name $Name -ErrorAction SilentlyContinue) {

        Set-ItemProperty `
            -Path $RegPath `
            -Name $Name `
            -Value $RegistrySettings[$Name]

    }
    else {

        New-ItemProperty `
            -Path $RegPath `
            -Name $Name `
            -PropertyType DWord `
            -Value $RegistrySettings[$Name] `
            -Force | Out-Null
    }
}

# Verify remediation
Write-Host "`nVerification Results:" -ForegroundColor Cyan

Get-ItemProperty -Path $RegPath | Select-Object `
    UseAdvancedStartup,
    UseTPM,
    UseTPMPIN,
    MinimumPIN
