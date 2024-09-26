<#
.SYNOPSIS
Checks for debloat folder and log
.NOTES
Written by John Johnson on 09/26/2024
#>

$DebloatFolder = "C:\ProgramData\Debloat"
if (Test-Path $DebloatFolder) {
    Write-Host "$DebloatFolder exists. Checking for log."
    if(Test-Path "$DebloatFolder\debloat.log"){
        Write-Host "Log found - no remediation required."
        # Return no error code to Intune
        exit 0
    } else {
        Write-Host "$DebloatFolder\debloat.log not found - remediation required."
        # Reutrn error code to Intune, flagging for remediation
        exit 1
    }
}
else {
    Write-Host "$DebloatFolder not found - remediation required."
    # Reutrn error code to Intune, flagging for remediation
    exit 1
}
