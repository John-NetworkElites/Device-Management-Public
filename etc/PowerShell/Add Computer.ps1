# Specify the computer info
$serialNumber = $((gwmi win32_bios).serialnumber)
$computerName = "EDHC$($serialNumber.subsrring(0, 10))"
$i = 0;

# Specify the AD Groups to add the computer to
$groupName = "Intune Enrollment"

#Join Domain with new computer name - does not check for existing Serialnumber
add-computer -domainname corp.edhc.com -newname $computerName

# Add the computer to the group
Add-ADGroupMember -Identity $groupName -Members $computerName -ErrorAction SilentlyContinue
