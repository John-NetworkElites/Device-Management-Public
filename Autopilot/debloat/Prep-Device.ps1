$DebloatFolder = "C:\ProgramData\Debloat"
If (Test-Path $DebloatFolder) {
    Write-Output "$DebloatFolder exists. Skipping."
}
Else {
    Write-Output "The folder '$DebloatFolder' doesn't exist. This folder will be used for storing logs created after the script runs. Creating now."
    Start-Sleep 1
    New-Item -Path "$DebloatFolder" -ItemType Directory
    Write-Output "The folder $DebloatFolder was successfully created."
}

$templateFilePath = "C:\ProgramData\Debloat\removebloat.ps1"

Invoke-WebRequest `
-Uri "https://raw.githubusercontent.com/andrew-s-taylor/public/main/De-Bloat/RemoveBloat.ps1" `
-OutFile $templateFilePath `
-UseBasicParsing `
-Headers @{"Cache-Control"="no-cache"}

invoke-expression -Command $templateFilePath

## Set other settings ##

function Set-Regkey {
    # Requires the full path of the registry key to set
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true)]
      [string] $FullPath,
      
      [Parameter(Mandatory=$true)]
      [string] $value
    )

    #Extract key from full path
    $key = Split-Path -Leaf $FullPath
    $path = Split-Path $FullPath
    try {
        Write-Output "`nAttempting to set $path\$key to $value..."
        If (!(Test-Path $path)) {
            New-Item $path
        }
        If (Test-Path $path) {
            Set-ItemProperty $path $key -Value $value
        }
        Write-Output "Successfully set $path\$key to $value"
    } catch {
        Write-Warning "`nThere was an issue writing $path\$key"
        Write-Warning $_
    }
}

function Remove-Regkey {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true)]
      [string] $path
    )
    try {
        Write-Output "`nAttempting to remove $path"
        If (Test-Path $path) {
           Remove-Item $path -Recurse
           Write-Output "Removed $path and its child items"
        } else {
            Write-Output "No path found at $path"
        }
    } catch {
        Write-Warning "`nThere was an issue removing"
        Write-Warning $_
    }
}

$RegkeysToSet = @{
    #Disable Bing from Search bar
    "HKLM:\Software\Policies\Microsoft\Windows\Explorer\DisableSearchBoxSuggestions" = 00000001
    #Remove chat from taskbar
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarMn" = 00000000
    #Tailored experiences with diagnostic data for Current User
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy\TailoredExperiencesWithDiagnosticDataEnabled" = 00000000
    #Disable Lockscreen tips
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338387Enabled" = 00000000
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\RotatingLockScreenOverlayEnabled" = 00000000
    #Disable Online Speech Regonition
    "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy\HasAccepted" = 00000000
    #Disable Improving Inking and Typing Recognition
    "HKCU:\Software\Microsoft\Input\TIPC\Enabled" = 00000000
    #Disable Widgets on Taskbar
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDa" = 00000000
    #Disable Widgets Service
    "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests\value" = 00000000
    "HKLM:\SOFTWARE\Policies\Microsoft\Dsh\AllowNewsAndInterests" = 00000000

}

$RegkeysToRemove = @(
    ## Remove Gallery and Home from quick access
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\Namespace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}"
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}"
    #Hide duplicate drives from Flie Explorer
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
)

ForEach ($Path in $RegkeysToSet.Keys){
    Set-Regkey -FullPath $Path -value $RegkeysToSet[$Path]
}

ForEach($Path in $RegkeysToRemove){
    Remove-Regkey -path $Path
}