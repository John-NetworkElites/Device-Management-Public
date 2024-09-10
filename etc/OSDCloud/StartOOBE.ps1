Write-Host  -ForegroundColor Blue "Loading OSD..."

Import-Module OSD -Force
Install-Module OSD -Force

Start-OOBEDeploy -AddNetFX3 -RemoveAppx  -SetEdition Enterprise -UpdateDrivers -UpdateWindows