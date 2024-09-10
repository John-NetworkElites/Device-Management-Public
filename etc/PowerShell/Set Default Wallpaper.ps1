# Get the desktop background image path.
$backgroundImagePath = "C:\Path\To\Desktop\Background.jpg"

# Get all default users on the system.
$users = Get-LocalUser -Filter {AccountType -eq "Default"}

# Set the desktop background for all default users.
foreach ($user in $users) {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "DesktopWallpaperPath" -Value $backgroundImagePath -User $user.Name
}