# Created by: John Johnson
# Created on: 06/18/2024


$appsList = @(
    #region Apps List

        # The apps below this line WILL be uninstalled. If you wish to KEEP any of the apps below
        #  simply add a # character in front of the specific app in the list below.
        #
        'Clipchamp.Clipchamp'
        'Microsoft.3DBuilder'
        'Microsoft.549981C3F5F10'   #Cortana app
        'Microsoft.BingFinance'
        'Microsoft.BingFoodAndDrink'       
        'Microsoft.BingHealthAndFitness'   
        'Microsoft.BingNews'
        'Microsoft.BingSports'
        'Microsoft.BingTranslator'
        'Microsoft.BingTravel'
        'Microsoft.BingWeather'
        #'Microsoft.Getstarted'   #Cannot be uninstalled in Windows 11
        'Microsoft.Messaging'
        'Microsoft.Microsoft3DViewer'
        'Microsoft.MicrosoftOfficeHub'
        'Microsoft.MicrosoftPowerBIForWindows'
        'Microsoft.MicrosoftSolitaireCollection'
        #'Microsoft.MicrosoftStickyNotes'
        'Microsoft.MixedReality.Portal'
        'Microsoft.NetworkSpeedTest'
        'Microsoft.News'
        'Microsoft.Office.OneNote'
        'Microsoft.Office.Sway'
        'Microsoft.OneConnect'
        #'Microsoft.Print3D'
        'Microsoft.SkypeApp'
        'Microsoft.Todos'
        'Microsoft.WindowsAlarms'
        'Microsoft.WindowsFeedbackHub'
        'Microsoft.WindowsMaps'
        'Microsoft.WindowsSoundRecorder'
        'Microsoft.XboxApp'   # Old Xbox Console Companion App, no longer supported
        'Microsoft.ZuneVideo'
        'MicrosoftTeams'   # Only removes the personal version (MS Store), does not remove business/enterprise version of teams
        
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
        
        #'Microsoft.GetHelp'                      # Required for some Windows 11 Troubleshooters
        #'Microsoft.MSPaint'                      # Paint 3D
        'Microsoft.OutlookForWindows'            # New mail app
        #'Microsoft.Paint'                        # Classic Paint
        'Microsoft.People'                       # Required for & included with Mail & Calendar
        'Microsoft.PowerAutomateDesktop'
        #'Microsoft.RemoteDesktop'
        #'Microsoft.ScreenSketch'                 # Snipping Tool
        'Microsoft.Whiteboard'                   # Only preinstalled on devices with touchscreen and/or pen support
        #'Microsoft.Windows.Photos'
        #'Microsoft.WindowsCalculator'
        #'Microsoft.WindowsCamera'
        'Microsoft.windowscommunicationsapps'    # Mail & Calendar
        #'Microsoft.WindowsStore'              # Microsoft Store, WARNING: This app cannot be reinstalled!
        #'Microsoft.WindowsTerminal'              # New default terminal app in windows 11
        'Microsoft.Xbox.TCUI'                    # UI framework, seems to be required for MS store, photos and certain games
        'Microsoft.XboxIdentityProvider'         # Xbox sign-in framework, required for some games
        'Microsoft.XboxSpeechToTextOverlay'      # Might be required for some games, WARNING: This app cannot be reinstalled!
        'Microsoft.YourPhone'                    # Phone link
        'Microsoft.ZuneMusic'                    # Modern Media Player
        
        'Microsoft.GamingApp'            # Modern Xbox Gaming App, required for installing some PC games
        'Microsoft.XboxGameOverlay'            # Game overlay, required/useful for some games
        'Microsoft.XboxGamingOverlay'            # Game overlay, required/useful for some games
        
    #endregion
)

# Reads list of apps and removes them for all user accounts and from the OS image.
function RemoveApps {

    Write-Output $message

    # Get list of apps and remove them one by one
    Foreach ($app in $appsList) 
    {
        Write-Output "Attempting to remove $app..."

        try {
            # Remove installed app for all existing users
            Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage

            # Remove provisioned app from OS image, so the app won't be installed for any new users
            Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $app } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $_.PackageName }
        }
        catch {
            Write-Error "Error removing $app..."
            Write-Error $_
        }
    }

    Write-Output ""
}

RemoveApps