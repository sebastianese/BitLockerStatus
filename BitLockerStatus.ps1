<#.DESCRIPTION
   Author: Sebastian Schlesinger 
   Date: 8/30/2017
			Script that will test the bitlocker status.
            Results will be sent via email.  
            
            
            Pre-requirements:
            Define the follwing variables: 
            A)$Servers = Servers to test the Bitlocker status. Need to be quoted and separated bye a comma. 
            B)$Users = Email recipients 
            C)$Fromemail = Source email address for report
            D)$Server = SMTP Server 

#>


$users = "UserName <User@Company.com>"
$fromemail = "Bitlocker Checker <BitlockerCheck@Company.com>" 
$server = "SMTP Server IP" 
$CurrentTime = Get-Date
$Servers = "Server1", "Server2" 



Function GetBLStatus($ComputerName) 
{ 
    #Script block 
    $Scope = { manage-bde -cn $Env:COMPUTERNAME -status } 
    Try 
    { 
        #Invoke command to remoted computer 
        $Obj = Invoke-Command -ComputerName $ComputerName -ScriptBlock $Scope  
        $Obj | select -First ($Obj.length-1) | select -Skip 3 
    } 
    Catch  
    { 
     Write-Error $_  
    } 
    Write-Host  
}

$Body = GetBLStatus -ComputerName $Servers  | Out-String
send-mailmessage   -from $fromemail -to $users -subject "Bitlocker Check completed At $CurrentTime"  -Body $Body  -priority Normal -smtpServer $server
 

