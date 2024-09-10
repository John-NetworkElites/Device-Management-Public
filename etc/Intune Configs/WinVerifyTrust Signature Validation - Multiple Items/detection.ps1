## Detection Script for WinVerifyTrust Signature Validation CVE-2013-3900 Mitigation (EnableCertPaddingCheck) ##
# Ticket: https://jira-edhc.atlassian.net/browse/SS-898

# 
# Configured by John Johnson on 05/06/2024
# Modified by John Johnson on 07/22/2024 to add additional path - HKLM:\SOFTWARE\Wow6432Node\Microsoft\Cryptography\Wintrust\Config\EnableCertPaddingCheck
# Update ticket: https://jira-edhc.atlassian.net/browse/SS-1476
#
# Source: https://scloud.work/registry-key-with-intune/

$Paths = @(
            "HKLM:\SOFTWARE\Microsoft\Cryptography\Wintrust\Config\"
            "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Cryptography\Wintrust\Config\"
            )
$Name = "EnableCertPaddingCheck"
$Value = 1
$Message = "-- WinVerify Detection Results For Host $Env:COMPUTERNAME --"

# Check each path in $Paths
ForEach ($Path in $Paths)
{
    # Get next iteration of path in loop
    Try {
        $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    # If path exists and has correct value, update message
        If ($Registry -eq $Value){$Message += "`nCompliant: $Path `nNo action required`n"}
    # If path exists but has incorrect value, update message with error
        Else {$Message += "`nNot Compliant `nIncorrect Value: $Path `nRequires Remediation"}
    }

    # If path does not exist, update message with error
    Catch {
        $Message += "`nNot Compliant `nPath not found: $Path `nRequires Remediation"
    }
}

# Evaluate message for compliancy, mark as compliant or non-compliant, and write to console
If ($Message.Contains("Not Compliant")){
    Write-Warning $Message
    Exit 1
}
Elseif ($Message.Contains("No action required")){
    Write-Output $Message
    Exit 0
}
# If for some reason the above conditions aren't met, let us know
Else {Write-Error "Error assigning compliancy: `n$Message"}