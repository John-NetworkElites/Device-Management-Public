#Export current layout
Export-StartLayout -Path "C:\StartMenuAndTaskbarLayout.json" -Taskbar

# Import the Start menu and taskbar layout for default users.
Import-StartLayout -Path "C:\StartMenuAndTaskbarLayout.json" -MountPath "C:\" -Taskbar

# Set the current Start menu and taskbar layout for default users.
$users = Get-LocalUser -Filter {AccountType -eq "Default"}
foreach ($user in $users) {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartLayout\Desktop" -Name "LayoutPath" -Value "C:\StartMenuAndTaskbarLayout.json"
}
