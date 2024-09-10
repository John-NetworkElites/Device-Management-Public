# Active Directory
Import-Module ActiveDirectory

# Basic Info
$FirstName = Read-Host "Enter First Name"
$Surname = Read-Host "Enter Last Name"
$Username = "$($FirstName).$($Surname)"
$Password = Read-Host "Enter password" | ConvertTo-SecureString -AsPlainText -Force

#Organizational
$Manager = Read-Host "Enter Manager's First and Last Name"
$Title = Read-Host "Enter Job Title"
$Department = Read-Host "Enter Department"
$StartDate = Read-Host "Enter Employee Start Date (DDMMYY)"

#Mirroring
$ADgroups = Read-Host "Copy AD group membership from which user?"

# Creating Displayname, First name, surname, samaccountname, UPN, etc and entering and a password for the user.
 New-ADUser `
-Name "$FirstName $Surname" `
-GivenName $FirstName `
-Surname $Surname `
-SamAccountName $Username `
-UserPrincipalName $Username@edhc.com `
-EmailAddress $Username@edhc.com `
-Company "EDHC" `
-Displayname "$FirstName $Surname" `
#-Path "CN=Users,DC=domain,DC=com" `
-Path "OU=People,DC=corp, DC=edhc,DC=com" `
-AccountPassword $Password 

# Set required details
Set-ADUser $Username -Enabled $True
Set-ADUser $Username -ChangePasswordAtLogon $False 
Set-ADUser $Username -EmailAddress "$Username@edhc.com"

#Set Manager
Set-ADUser $Username -Manager $Manager

# Finds all the AD-groups that the "$ADGroups" user you entered is a part of and adds it to the new user automatically.
Get-ADPrincipalGroupMembership -Identity $ADgroups | select SamAccountName | ForEach-Object {Add-ADGroupMember -Identity $_.SamAccountName -Members  $Username }

Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete!"