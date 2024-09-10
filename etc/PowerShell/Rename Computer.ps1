# Specify the computer info
$serialNumber = $((gwmi win32_bios).serialnumber)

# Specify Naming Schema
$computerName = "EDHC$($serialnumber)"

# Rename Computer
Rename-Computer -NewName $computerName