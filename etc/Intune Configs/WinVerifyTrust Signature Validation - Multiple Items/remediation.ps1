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
$Key = "EnableCertPaddingCheck"
$KeyFormat = "String"
$Value = 1

#Attempt to remediate all paths
ForEach ($Path in $Paths){
    try{
        if(!(Test-Path $Path)){New-Item -Path $Path -Force}
        if(!$Key){Set-Item -Path $Path -Value $Value}
        else{Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}
        Write-Output "Key set at $Path : `n$Key = $Value"
    }catch{
        Write-Error $_
    }
}