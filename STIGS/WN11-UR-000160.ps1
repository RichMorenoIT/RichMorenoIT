
 <#
.SYNOPSIS
    This PowerShell script ensures that the "Restore files and directories" user right must only be assigned to the Administrators group

.NOTES
    Author          : Ricardo Moreno
    LinkedIn        : linkedin.com/in/ricardo-moreno-0177762b8
    GitHub          : github.com/RichMorenoIT
    Date Created    : 2026-29-07
    Last Modified   : 2026-29-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-UR-000160

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-UR-000160.ps1 
#>


# ===================================================================
# WN11-UR-000160 Remediation
# Restore files and directories -> Administrators only
# Run as Administrator
# ===================================================================

$tempInf = "$env:TEMP\secpol.inf"
$tempDb  = "$env:TEMP\secedit.sdb"

# Export current security policy
secedit /export /cfg $tempInf | Out-Null

# Read policy
$content = Get-Content $tempInf

# SID for Built-in Administrators
$admins = "*S-1-5-32-544"

# Replace or create SeRestorePrivilege
if ($content -match "^SeRestorePrivilege") {
    $content = $content -replace "^SeRestorePrivilege\s*=.*", "SeRestorePrivilege = $admins"
}
else {
    $index = ($content | Select-String "^\[Privilege Rights\]").LineNumber
    if ($index) {
        $before = $content[0..($index-1)]
        $after  = $content[$index..($content.Count-1)]
        $content = $before + $after[0] + "SeRestorePrivilege = $admins" + $after[1..($after.Count-1)]
    }
}

# Save updated INF
$content | Set-Content $tempInf -Encoding Unicode

# Import security policy
secedit /configure `
    /db $tempDb `
    /cfg $tempInf `
    /areas USER_RIGHTS | Out-Null

# Refresh policy
gpupdate /force

Write-Host ""
Write-Host "WN11-UR-000160 remediation completed." -ForegroundColor Green
Write-Host "A reboot is recommended before rescanning."

secedit /export /cfg "$env:TEMP\verify.inf" | Out-Null
Select-String "SeRestorePrivilege" "$env:TEMP\verify.inf"
