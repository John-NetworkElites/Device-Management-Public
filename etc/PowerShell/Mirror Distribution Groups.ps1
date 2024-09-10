# Import the Exchange Online PowerShell module
#Import-Module ExchangeOnlineManagement



# Try to get all the Exchange Online Distribution groups that the first user is a member of, and add the second user to those same groups
try {
    #Connect to Exchange Online
    Connect-ExchangeOnline -ShowBanner:$False

    # Prompt the user for the first user's identity
    $user1 = Read-Host "Enter the identity of the user to mirror FROM"

    # Prompt the user for the second user's identity
    $user2 = Read-Host "Enter the identity of the user to mirror TO"

    # Check if the first user exists
    # Try to get the user objects from the Azure Active Directory
    #try {
    # Get the first user object
    #$user1 = Get-MsolUser -UserPrincipalName $user1

    # Get the second user object
    #$user2 = Get-MsolUser -UserPrincipalName $user2
#}

    # Catch any errors that occur
    #catch {
    # Write an error message
    #Write-Error "An error occurred while getting the user objects: $_.Exception.Message"

    # Exit the script
    #exit
#}

    # Check if the first user object is null
    #if ($user1 -eq $null) {
    #Write-Error "The first user '$user1' does not exist."
    #exit
#}

    # Check if the second user object is null
    #if ($user2 -eq $null) {
    #Write-Error "The second user '$user2' does not exist."
    #exit
#}

    # The users exist
    #Write-Host "The users '$user1' and '$user2' exist."

    # Get all the Exchange Online Distribution groups that the first user is a member of
    $distributionGroups = Get-DistributionGroupMember -Identity $user1 | Select-Object -ExpandProperty PrimarySmtpAddress

    # Add the second user to all the Distribution groups that the first user is a member of
    foreach ($distributionGroup in $distributionGroups) {
        Add-DistributionGroupMember -Identity $distributionGroup -Member $user2
    }

    # Write a success message
    Write-Host "The second user '$user2' has been added to all the Distribution groups that the first user '$user1' is a member of."
}

# Catch any errors that occur
catch {
    # Write an error message
    Write-Error "An error occurred: $_.Exception.Message"
}