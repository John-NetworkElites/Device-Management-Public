<#
.SYNOPSIS
Script for migrating users from one primary domain to another
#>

#Install or update needed modules if necessary
##Install-Module Azure -force
##Install-Module MSOnline -Force

Write-Host  "Please log in to current domain with GA crednetials"
Read-Host   "Press any button to confirm and continue...`n"
try {
    Connect-MsolService
}
catch {
    Write-Warning "There was an error with authentication. Exiting..."
    Write-Error $_
}

$oldDomain = Read-Host "Name of old domain"
$newDomain = Read-Host "Name of new domain"

$excludedUPNS = @(
    "_svc_PowerPlatform@victorydevelopment.com"
    "asmigrationadmin@victorydevelopment01.onmicrosoft.com"
    "btaitbuilders@victorydevelopment.com"
    "berkscg@victorydevelopment.com"
    "buildinginvoices@victorydevelopment.com"
    "cattlemen@victorydevelopment.com"
    "clout@victorydevelopment.com"
    "nemigadmin@victorydevelopment01.onmicrosoft.com"
    "sharpcon@victorydevelopment.com"
    "stellar@victorydevelopment.com"
    "TenantServicePrincipal@victorydevelopment01.onmicrosoft.com"
    "admin@victorydevelopment01.onmicrosoft.com"
    "VOIPauto@victorydevelopment01.onmicrosoft.com"
    "vredmain@victorydevelopment01.onmicrosoft.com"
    "Vred-main@victorydevelopment01.onmicrosoft.com"
    "vredinvoices@victorydevelopment.com"
    "VRED-Main@victorydevelopment.com"
)

# Use the foreach switch to filter out users whose UPN is in the excludedUPNs array
Get-MsolUser -All | ForEach-Object -Process {
    # If the current user's UPN is in the excludedUPNs array, output it
    if ($excludedUPNs -contains $_.UserPrincipalName) {
        $_
    }
} | Select-Object UserPrincipalName, DisplayName, isLicensed, BlockCredential


#Get all users in domain that have old domain as UPN and save as variable
$users = Get-MsolUser -All | Select-Object UserPrincipalName, DisplayName, isLicensed, BlockCredential

#Filter out unlicened andbBlocked accounts (print this)


#Save previous UPN as a variable
#Change UPN
#Assign old UPN as an alias

foreach ($user in $users){
    #If user's old domain name matches and is not in exclusion list:
        #Capture old UPN and split into username and domain
        $oldUPN = $user.UserPrincipalName
        $username = $oldUPN.split("@")[0]

        #Define the new UPN by appending the new domain
        $newUPN = "$username@$newDomain"
        Write-Host "Changing UPN for $($user.DisplayName): $oldUPN -> $newUPN"
    
        try {
            $currentAliases = $user.ProxyAddresses
            # Set-MsolUserPrincipalName -UserPrincipalName $oldUPN -NewUserPrincipalName $newUPN -WhatIf
    
            # Add the old UPN as a proxy address (email alias)
            $newAlias = "smtp:$oldUPN"
            
            # If the user has existing aliases, add the old UPN as another alias
            if ($currentAliases) {
                $updatedAliases = $currentAliases + $newAlias
            } else {
                $updatedAliases = @($newAlias)
            }
    
            # Update the user's proxy addresses with the old UPN as an alias
            Set-Mailbox -Identity $newUPN -EmailAddresses $updatedAliases
            
            Write-Host "Added old UPN $oldUPN as alias to $newUPN"
        } catch {
            Write-Host "Error processing $($user.DisplayName): $($_.Exception.Message)"
        }
    
        Write-Host "------------------------------"
}

#Set new domain to Primary?