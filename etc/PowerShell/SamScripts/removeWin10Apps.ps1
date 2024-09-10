 
$installedApps =  Get-AppxProvisionedPackage -Online 
 
$installedApps | Where-Object DisplayName -like *xbox* | Remove-AppxProvisionedPackage -Online
$installedApps | Where-Object DisplayName -like *zune* | Remove-AppxProvisionedPackage -Online
$installedApps | Where-Object DisplayName -like *messaging* | Remove-AppxProvisionedPackage -Online
$installedApps | Where-Object DisplayName -like *solitaire* | Remove-AppxProvisionedPackage -Online
$installedApps | Where-Object DisplayName -like *skype* | Remove-AppxProvisionedPackage -Online
$installedApps | Where-Object DisplayName -like *feedbackhub* | Remove-AppxProvisionedPackage -Online
$installedApps | Where-Object DisplayName -like *getstarted* | Remove-AppxProvisionedPackage -Online
$installedApps | Where-Object DisplayName -like *gethelp* | Remove-AppxProvisionedPackage -Online

$installedApps =  Get-AppxProvisionedPackage -Online 
$installedApps

