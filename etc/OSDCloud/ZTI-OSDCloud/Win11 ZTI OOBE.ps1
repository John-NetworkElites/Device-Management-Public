#Sources: https://raw.githubusercontent.com/AkosBakos/OSDCloud/main/ScriptPad/W11_OOBEcmd.ps1
#         https://akosbakos.ch/osdcloud-9-oobe-challenges/

#================================================
#   [PreOS] Update Module
#================================================
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force   

#=======================================================================
#   [OS] Params and Start-OSDCloud
#=======================================================================
$Params = @{
    OSVersion = "Windows 11"
    OSBuild = "23H2"
    OSEdition = "Pro"
    OSLanguage = "en-us"
    OSLicense = "Retail"
    ZTI = $true
    Firmware = $true
}
Start-OSDCloud @Params

#================================================
#  [PostOS] OOBEDeploy Configuration
#================================================
Write-Host -ForegroundColor Green "Create C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json"
$OOBEDeployJson = @'
{
    "AddNetFX3":  {
                      "IsPresent":  true
                  },
    "Autopilot":  {
                      "IsPresent":  false
                  },
    "RemoveAppx":  [
                    "Clipchamp.Clipchamp"
                    "Microsoft.3DBuilder"
                    "Microsoft.549981C3F5F10"
                    'Microsoft.BingFinance'
                    'Microsoft.BingFoodAndDrink'       
                    'Microsoft.BingHealthAndFitness'   
                    'Microsoft.BingNews'
                    'Microsoft.BingSports'
                    'Microsoft.BingTranslator'
                    'Microsoft.BingTravel'
                    'Microsoft.BingWeather'
                    'Microsoft.Messaging'
                    'Microsoft.Microsoft3DViewer'
                    'Microsoft.MicrosoftOfficeHub'
                    'Microsoft.MicrosoftPowerBIForWindows'
                    'Microsoft.MicrosoftSolitaireCollection'
                    'Microsoft.MixedReality.Portal'
                    'Microsoft.NetworkSpeedTest'
                    'Microsoft.News'
                    'Microsoft.Office.OneNote'
                    'Microsoft.Office.Sway'
                    'Microsoft.OneConnect'
                    'Microsoft.SkypeApp'
                    'Microsoft.Todos'
                    'Microsoft.WindowsAlarms'
                    'Microsoft.WindowsFeedbackHub'
                    'Microsoft.WindowsMaps'
                    'Microsoft.WindowsSoundRecorder'
                    'Microsoft.XboxApp'
                    'Microsoft.ZuneVideo'
                    'MicrosoftTeams'
                    'ACGMediaPlayer'
                    'ActiproSoftwareLLC'
                    'AdobeSystemsIncorporated.AdobePhotoshopExpress'
                    'Amazon.com.Amazon'
                    'AmazonVideo.PrimeVideo'
                    'Asphalt8Airborne '
                    'AutodeskSketchBook'
                    'CaesarsSlotsFreeCasino'
                    'COOKINGFEVER'
                    'CyberLinkMediaSuiteEssentials'
                    'DisneyMagicKingdoms'
                    'Disney'
                    'Dolby'
                    'DrawboardPDF'
                    'Duolingo-LearnLanguagesforFree'
                    'EclipseManager'
                    'Facebook'
                    'FarmVille2CountryEscape'
                    'fitbit'
                    'Flipboard'
                    'HiddenCity'
                    'HULULLC.HULUPLUS'
                    'iHeartRadio'
                    'Instagram'
                    'king.com.BubbleWitch3Saga'
                    'king.com.CandyCrushSaga'
                    'king.com.CandyCrushSodaSaga'
                    'LinkedInforWindows'
                    'MarchofEmpires'
                    'Netflix'
                    'NYTCrossword'
                    'OneCalendar'
                    'PandoraMediaInc'
                    'PhototasticCollage'
                    'PicsArt-PhotoStudio'
                    'Plex'
                    'PolarrPhotoEditorAcademicEdition'
                    'Royal Revolt'
                    'Shazam'
                    'Sidia.LiveWallpaper'
                    'SlingTV'
                    'Speed Test'
                    'Spotify'
                    'TikTok'
                    'TuneInRadio'
                    'Twitter'
                    'Viber'
                    'WinZipUniversal'
                    'Wunderlist'
                    'XING'                    
                    'Microsoft.OutlookForWindows'            
                    'Microsoft.People'                       
                    'Microsoft.PowerAutomateDesktop'
                    'Microsoft.Whiteboard'                   
                    'Microsoft.windowscommunicationsapps'   
                    'Microsoft.Xbox.TCUI'                    
                    'Microsoft.XboxIdentityProvider'        
                    'Microsoft.XboxSpeechToTextOverlay'      
                    'Microsoft.YourPhone'                   
                    'Microsoft.ZuneMusic'                   
                    'Microsoft.GamingApp'            # 
                    'Microsoft.XboxGameOverlay'            
                    'Microsoft.XboxGamingOverlay'
                   ],
    "UpdateDrivers":  {
                          "IsPresent":  true
                      },
    "UpdateWindows":  {
                          "IsPresent":  true
                      }
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$OOBEDeployJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json" -Encoding ascii -Force

#================================================
#  [PostOS] AutopilotOOBE Configuration Staging
#================================================
Write-Host -ForegroundColor Green "Define Computername:"
$Serial = Get-WmiObject Win32_bios | Select-Object -ExpandProperty SerialNumber
$TargetComputername = $Serial.Substring(4,3)

$AssignedComputerName = "EDHC$TargetComputername"
Write-Host -ForegroundColor Red $AssignedComputerName
Write-Host ""

Write-Host -ForegroundColor Green "Create C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json"
$AutopilotOOBEJson = @"
{
    "AssignedComputerName" : "$AssignedComputerName",
    "AddToGroup":  "AADGroupX",
    "Assign":  {
                   "IsPresent":  true
               },
    "GroupTag":  "GroupTagXXX",
    "Hidden":  [
                   "AddToGroup",
                   "AssignedUser",
                   "PostAction",
                   "GroupTag",
                   "Assign"
               ],
    "PostAction":  "Quit",
    "Run":  "NetworkingWireless",
    "Docs":  "https://google.com/",
    "Title":  "Autopilot Manual Register"
}
"@

If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$AutopilotOOBEJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json" -Encoding ascii -Force

#================================================
#  [PostOS] AutopilotOOBE CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\System32\OOBE.cmd"
$OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Install-Module AutopilotOOBE -Force -Verbose
Start /Wait PowerShell -NoL -C Install-Module OSD -Force -Verbose
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/AkosBakos/OSDCloud/main/Set-KeyboardLanguage.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/AkosBakos/OSDCloud/main/Install-EmbeddedProductKey.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://check-autopilotprereq.osdcloud.ch
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://start-autopilotoobe.osdcloud.ch
Start /Wait PowerShell -NoL -C Start-OOBEDeploy
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://tpm.osdcloud.ch
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/AkosBakos/OSDCloud/main/Lenovo_BIOS_Settings.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://cleanup.osdcloud.ch
Start /Wait PowerShell -NoL -C Restart-Computer -Force
'@
$OOBECMD | Out-File -FilePath 'C:\Windows\System32\OOBE.cmd' -Encoding ascii -Force

#================================================
#  [PostOS] SetupComplete CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\SetupComplete.cmd"
$SetupCompleteCMD = @'
powershell.exe -Command Set-ExecutionPolicy RemoteSigned -Force
powershell.exe -Command "& {IEX (IRM oobetasks.osdcloud.ch)}"
'@
$SetupCompleteCMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\SetupComplete.cmd' -Encoding ascii -Force

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot