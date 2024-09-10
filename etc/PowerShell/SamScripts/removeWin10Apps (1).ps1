 
$installedApps =  Get-AppxProvisionedPackage -Online 
 
$installedApps | Where-Object DisplayName -like *xbox* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *zune* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *messaging* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *solitaire* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *skype* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *feedbackhub* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *getstarted* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *gethelp* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *whatsapp* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *espn* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *prime* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *instag* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *netflix* | Remove-AppxProvisionedPackage -Online -allusers
$installedApps | Where-Object DisplayName -like *clip* | Remove-AppxProvisionedPackage -Online -allusers

$installedApps =  Get-AppxProvisionedPackage -Online 
$installedApps

