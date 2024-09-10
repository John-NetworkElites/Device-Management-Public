# Uninstall bloatware
$bloatware = Get-AppxPackage | Where-Object {$_.PackageFullName -notlike "*Microsoft.*"} | Where-Object {$_.PackageFullName -notlike "*Windows.*"} | Where-Object {$_.PackageFullName -notlike "*Store.*"}
foreach ($app in $bloatware) {
    Remove-AppxPackage $app.PackageFullName -AllUsers
    Disable-AppXProvisionedPackage -Online -PackageName $app.PackageName -AllUsers
}

#Uninstall bloatware pt 2
$appxPackagesToRemove = @("Microsoft.XboxGamingOverlay", "Microsoft.XboxLiveGameSave", "Microsoft.ZuneVideo")
foreach ($app in $appxPackagesToRemove) {
    Remove-AppxPackage $app.PackageFullName -AllUsers
}

# Set dark mode
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0

# Set time to CST
Set-TimeZone -Name "Central Standard Time"

# Set power settings to best performance
PowerCfg -SetActiveScheme -SchemeName "High performance"
# Set power properties to turn off screen at 5 minutes on battery, 10 minutes when plugged in.
powercfg -setdcvalueindex scheme_current sub_video videotimeout_ac 10
powercfg -setdcvalueindex scheme_current sub_video videotimeout_dc 5
# Set power properties to put computer to sleep after 30 minutes on battery, never when plugged in.
powercfg -setdcvalueindex scheme_current sub_sleep sleepsub_timeout_ac 0
powercfg -setdcvalueindex scheme_current sub_sleep sleepsub_timeout_dc 1800
# Set power properties to set hard disk to never turn off on battery or when plugged in.
powercfg -setdcvalueindex scheme_current sub_disk disktimeout_ac 0
powercfg -setdcvalueindex scheme_current sub_disk disktimeout_dc 0
# Set power properties to set lid to do nothing when closed when plugged in, sleep when on battery.
powercfg -setdcvalueindex scheme_current sub_power lidacclosed 0
powercfg -setdcvalueindex scheme_current sub_power lidcloseddc 1
# Save changes.
powercfg -SetActiveScheme -SchemeName "Current Power Plan"

# Run all Windows updates
Start-Process -FilePath "C:\Windows\System32\wuapp.exe" -ArgumentList "-update now"

# Install optional Windows feature .NET Framework 3.5
Enable-WindowsOptionalFeature -Online -FeatureName NetFx3

# Disable the Xbox Game DVR service.
Set-Service -Name XboxGipSvc -StartupType Disabled

# Disable the Xbox Live service.
Set-Service -Name XblAuthManager -StartupType Disabled

# Restart the computer.
Restart-Computer