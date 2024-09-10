# update the registry key 
#  HKLM\SOFTWARE\LENOVO\VantageService  32bitview
#  IsProloadInstallCompleted = "false"
pushd $PSScriptRoot
$key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry32)
$subKey =  $key.OpenSubKey("SOFTWARE\LENOVO\VantageService", $True)
$subKey.SetValue("IsProloadInstallCompleted", "false")
$root = $subKey.GetValue("IsProloadInstallCompleted")

Write-Output $root

# update hypothesis and config servcie.
&./VantageComponentUpdater.exe

popd