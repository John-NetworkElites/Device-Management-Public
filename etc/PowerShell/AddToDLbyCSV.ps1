#Install-Module ExchangeOnlineManagement

#Parameters
$DistributionList = "referrals@edhc.com" # Group-Name or Group Email
$CSVFilePath = "C:\Users\john.johnson\OneDrive - EDHC\temp\userstoadd.csv"
 
Try {
    #Connect to Exchange Online
    Connect-ExchangeOnline -ShowBanner:$False
 
     Import-CSV $CSVFilePath | foreach{
     
     $user=$_.Email

     Write-Progress -Activity "Adding $user to group… " 
     Add-DistributionGroupMember –Identity $DistributionList -Member $user  
     If($?)
     {  
        Write-Host $UPN Successfully added -ForegroundColor Green 
     }
     Else
     {  
        Write-Host $UPN - Error occurred –ForegroundColor Red
     }
   }       

}
Catch {
    write-host -f Red "Error:" $_.Exception.Message
}