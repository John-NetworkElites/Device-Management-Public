# Import the Active Directory module
Import-Module activedirectory

# Get the user name from the user
Write-Host "Enter the user name: "
$username = Read-Host

# Check if the user exists
$user = Get-ADUser -Identity $username

# If the user exists, print the names of the security groups
if ($user) {
  $groups = Get-ADPrincipalGroupMembership $username

  Write-Host "The security groups that the user is a member of are:"
  foreach ($group in $groups) {
    Write-Host $group.Name
  }
}

# Otherwise, print an error message
else {
  Write-Error "The user does not exist"
}

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');