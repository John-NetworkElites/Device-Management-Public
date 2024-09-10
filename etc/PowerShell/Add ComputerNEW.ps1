# Specify the computer info
$serialNumber = $((gwmi win32_bios).serialnumber)
$computerName = "EDHC$($serialnumber)"

#Join Domain with new computer name - does not check for existing Serialnumber
add-computer -domainname corp.edhc.com -newname $computerName -Restart
