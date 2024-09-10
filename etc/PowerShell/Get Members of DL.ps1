#Parameters
$DistributionList = "All@edhc.com" # Group-Name or Group Email
$CSVFilePath = "C:\Temp\ALLEDHC-DL-Members.csv"
 
Try {
    #Connect to Exchange Online
    Connect-ExchangeOnline -ShowBanner:$False
 
    #Get Distribution List Members and Exports to CSV
    Get-DistributionGroupMember -Identity $DistributionList -ResultSize Unlimited | Select Name, PrimarySMTPAddress, RecipientType | Export-Csv $CSVFilePath -NoTypeInformation
}
Catch {
    write-host -f Red "Error:" $_.Exception.Message
}


#Read more: https://www.sharepointdiary.com/2022/03/office-365-export-distribution-list-members-to-csv-using-powershell.html#ixzz8EikJyTrz UTF8