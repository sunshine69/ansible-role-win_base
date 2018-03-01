<#  
.Synopsis 
This function will get the offline disk(s) on Windows Server and attempts to bring them online. 
.Description  
The CmdLet would use the diskpart.exe to find the offline disk(s) and enable them. 
The CmdLet would also support Windows 2008, Windows 2008 R2, Server 2012 and Server 2012 R2 with no dependency over the 'Storage Module' 
.Example 
Enable-OfflineDisk 
 
Following Offline disk(s) found..Trying to bring Online. 
  Disk 1    Offline        3072 MB  1984 KB          
  Disk 2    Offline        4096 MB  1024 KB          
Enabling Disk 1 
Enabling Disk 2 
Disk(s) are now online. 
#>  
 
Function Enable-OfflineDisk 
{ 
    $disk_number2drive_letter = @{}
{% for disk_item in win_base_extra_disk_list %}
    $disk_number2drive_letter['Disk {{ disk_item.number }}'] = '{{ disk_item.drive_letter }}'
{% endfor %}
 
    #Check for offline disks on server. 
    $offlinedisk = "list disk" | diskpart | where {$_ -match "offline"} 
     
    #If offline disk(s) exist 
    if($offlinedisk) 
    { 
     
        Write-Output "Following Offline disk(s) found..Trying to bring Online." 
        $offlinedisk 
         
        #for all offline disk(s) found on the server 
        foreach($offdisk in $offlinedisk) 
        { 
     
            $offdiskS = $offdisk.Substring(2,6) 
            $disk_number = $offdisk.Substring(6,6)
            $drive_letter = $disk_number2drive_letter[$offdiskS]
            Write-Output "Enabling $offdiskS with drive letter $drive_letter" 
#Creating command parameters for selecting disk, making disk online and setting off the read-only flag. 
$OnlineDisk = @" 
select $offdiskS 
attributes disk clear readonly 
online disk 
attributes disk clear readonly 
select volume $disk_number 
assign letter $drive_letter
"@ 
            #Sending parameters to diskpart 
            $noOut = $OnlineDisk | diskpart 
            sleep 5 
     
       } 
 
        #If selfhealing failed throw the alert. 
        if(($offlinedisk = "list disk" | diskpart | where {$_ -match "offline"} )) 
        { 
         
            Write-Output "Failed to bring the following disk(s) online" 
            $offlinedisk 
 
        } 
        else 
        { 
     
            Write-Output "Disk(s) are now online." 
 
        } 
 
    } 
 
    #If no offline disk(s) exist. 
    else 
    { 
 
        #All disk(s) are online. 
        Write-Host "All disk(s) are online!" 
 
    } 
}
# Run it at last
Enable-OfflineDisk
