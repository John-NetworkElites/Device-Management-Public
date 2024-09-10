#region TO DO

    # DefaultGroup
    # Verify and implement manager name
    # Password creation based on name and title
    # User groups based on department

#endregion


#region User-input parameters
param (

    ## Name

    [Parameter(Mandatory,ValueFromPipelineByPropertyname)]
    [ValidateNotNullOrEmpty()]
    [string]$FirstName,
    [Parameter(Mandatory,ValueFromPipelineByPropertyname)]
    [ValidateNotNullOrEmpty()]
    [string]$LastName,
    ##[Parameter(Mandatory,ValueFromPipelineByPropertyname)]
    ##[ValidateNotNullOrEmpty()]
    ##[string]$MiddleInitial,

     ## Organizational Info

    [Parameter(Mandatory,ValueFromPipelineByPropertyname)]
    [ValidateNotNullOrEmpty()]
    [string]$Title,

    [Parameter(Mandatory,ValueFromPipelineByPropertyname)]
    [ValidateNotNullOrEmpty()]
    [string]$Department,

    ## Set & Check Manager

    [Parameter(Mandatory,ValueFromPipelineByPropertyname)]
    [ValidateNotNullOrEmpty()]
    [string]$Manager,

    [Parameter(ValueFromPipelineByPropertyname)]
    [ValidateNotNullOrEmpty()]
    [string]$Location = 'OU=People',
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$DefaultGroup = 'Domain Users',

    ## Password
    [Parameter(Mandatory,ValueFromPipelineByPropertyname)]
    [ValidateNotNullOrEmpty()]
    [string]$DefaultPassword
)
#endregion

#region Username Creation

##Figure out what the username will be based on our defined company standard, firstname.lastname

## Find the distinguished name of the domain the current computer is a part of.
$DomainDn = (Get-AdDomain).DistinguishedName

## Define the 'standard' username (first initial and last name)
$Username = "$($FirstName).$($LastName)"

## Check if an existing user already has the first name/last name username taken
Write-Verbose -Message "Checking if [$($Username)] is available"
if (Get-ADUser -Filter "Name -eq '$Username'")
{
    Write-Warning -Message "The username [$($Username)] is not available. Check alternate..."
    ## If so, check to see if the first initial/middle initial/last name is taken.
    <#$Username = "$($FirstName).$($MiddleInitial).$($LastName)"
    if (Get-ADUser -Filter "Name -eq '$Username'")
    {
throw "No acceptable username schema could be created"
    }
    else
    {
Write-Verbose -Message "The alternate username [$($Username)] is available."
    }#>
}
else
{
    Write-Verbose -Message "The username [$($Username)] is available"
}#>
#endregion


#region Ensure the OU the user's going into exists

$ouDN = "$Location,$DomainDn"
if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ouDN'"))
{
    throw "The user OU [$($ouDN)] does not exist. Can't add a user there"    
}
#endregion


#region Ensure the group the user's going into exists
<#if (-not (Get-ADGroup -Filter "Name -eq '$DefaultGroup'"))
{
    throw "The group [$($DefaultGroup)] does not exist. Can't add the user into this group."    
}
if (-not (Get-ADGroup -Filter "Name -eq '$Department'"))
{
    throw "The group [$($Department)] does not exist. Can't add the user to this group."    
}#>
#endregion

#region Verify Manager

if(Get-ADUser -Filter -eq $Manager)
    {
    Write-Verbose -Message "Manager, [$($Manager)] found. It will be set"
    }
    else{
        throw "Manager, [$($Manager)] was NOT found. It will NOT be set"
        }

#endregion

#region Create the new user with defined params
$NewUserParams = @{
    'UserPrincipalName' = "$($Username)@edhc.com"
    'Name' = $Username
    'GivenName' = $FirstName
    'Surname' = $LastName
    'Title' = $Title
            'Department' = $Department
    'SamAccountName' = $Username
    'AccountPassword' = (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force)
    'Enabled' = $true
    'Initials' = $MiddleInitial
    'Manager' = Get-ADUser -Filter $Manager
    'ChangePasswordAtLogon' = $false

}
Write-Verbose -Message "Creating the new user account [$($Username)] in OU [$($ouDN)]"
New-AdUser @NewUserParams
#endregion


#region Add user to groups
Write-Verbose -Message "Adding the user account [$($Username)] to the group [$($DefaultGroup)]"
Add-ADGroupMember -Members $Username -Identity $DefaultGroup
Write-Verbose -Message "Adding the user account [$($Username)] to the group [$($Department)]"
Add-ADGroupMember -Members $Username -Identity $Department
#endregion