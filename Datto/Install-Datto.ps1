# Configured by John Johnson on 09/06/2024
<# Intune Fields
Name: Datto RMM | Network Elites
Description: 
        # Remote management agent for Network Elites

        Places device in Network Elites agent by running script to download agent found in datto under:

        *Site* > Add Device > Use the installation command

        *See notes section in Intune for more details*
Publisher: Datto inc.
App Version: Script
Informational URL: https://concord.rmm.datto.com/site/266614/network-elites-services-llc/add-device
Developer: John Johnson
Owner: Aras Sahebi
Notes: Win32 app that deploys a script. Must install with the following command: powershell.exe -noprofile -executionpolicy bypass -file .\Install-Datto.ps1
Install Command: powershell.exe -noprofile -executionpolicy bypass -file .\Install-Datto.ps1
Uninstall Command: C:\Program Files (x86)\CentraStage\uninst.exe  
Detection:  C:\Program Files (x86)\CentraStage\CagService.exe
#>

try {
    # Places in Network Elites Site
    (New-Object System.Net.WebClient).DownloadFile("https://concord.centrastage.net/csm/profile/downloadAgent/fcd21407-1b80-4da5-bd2e-743dba450eb5", "$env:TEMP/AgentInstall.exe");start-process "$env:TEMP/AgentInstall.exe"
}
catch {
    Write-Error "There was an error installing Datto to $env:computername `n$_"
}