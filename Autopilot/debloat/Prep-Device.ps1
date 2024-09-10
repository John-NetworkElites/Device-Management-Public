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

Start-Process invoke-expression -Command $templateFilePath -Wait

## Set other settings ##

function Set-Regkey {
    # Requires the full path of the registry key to set
    (
      [Parameter(Mandatory=$true)]
      [string] $path,
      
      [Parameter(Mandatory=$true)]
      [string] $value
    )

    $key = $path.Substring($path.LastIndexOf('\'),$path.Length)
    $path = $path.Substring(0, $path.LastIndexOf('\'))
    try {
        Write-Output "Attempting to set $path\$key to $value..."
        If (!(Test-Path $path)) {
            New-Item $path
        }
        If (Test-Path $path) {
            Set-ItemProperty $path $key -Value $value
        }
        Write-Output "Successfully set $path\$key to $value"
    } catch {
        Write-Warning "There was an issue writing $path\$key"
        Write-Warning $_
    }
}

function Remove-Regkey {
    (
      [Parameter(Mandatory=$true)]
      [string] $path
    )
    try {
        Write-Output "Attempting to remove $path"
        If (Test-Path $path) {
           Remove-Item $path -Recurse
           Write-Output "Removed $path and its child items"
        } else {
            Write-Output "No path found at $path"
        }
    } catch {
        Write-Warning "There was an issue removing"
        Write-Warning $_
    }
}

$RegkeysToSet = @{
    #Disable Bing from Search bar
    "HKLM:\Software\Policies\Microsoft\Windows\Explorer\DisableSearchBoxSuggestions" = 00000001
    #Remove chat from taskbar
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarMn" = 00000000
    #Tailored experiences with diagnostic data for Current User
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy\TailoredExperiencesWithDiagnosticDataEnabled" = 00000000
}

$RegkeysToRemove = @(
    ## Remove Gallery and Home from quick access
    "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\e88865ea-0e1c-4e20-9aa6-edcd0212c87c"
    "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\f874310e-b6b7-47dc-bc84-b9e6b38f5903"
)

ForEach ($Path in $RegkeysToSet.Keys){
    Set-Regkey -path $Path -value $RegkeysToSet[$Path]
}

ForEach($Path in $RegkeysToRemove){
    Remove-Regkey -path $Path
}