Write-Host  -ForegroundColor Cyan "Starting EDHC Custom OSDCloud ..."
cls

Write-Host "======================================================="
Write-Host "=================== EDHC OSD Cloud ====================" -ForegroundColor Blue
Write-Host "=======================================================" -ForegroundColor Blue
Write-Host ""
Write-Host "1: Manual GUI"-ForegroundColor Cyan
Write-Host "2: Manual CLI"-ForegroundColor Cyan
Write-Host "3: Zero-Touch Win11 23H2 | English | Enterprise" -ForegroundColor Cyan
Write-Host "4: Exit"-ForegroundColor Cyan

$input = Read-Host "Please make a selection"

Write-Host  -ForegroundColor Blue "Loading OSDCloud..."

Import-Module OSD -Force
Install-Module OSD -Force

switch ($input)
{
    '1' { Start-OSDCloudGUI } 
    '2' { Start-OSDCloud } 
    '3' { Start-OSDCloud -OSLanguage en-us -OSBuild 23H2 -OSEdition Enterprise -ZTI } 
    '4' { Exit }
}

wpeutil reboot