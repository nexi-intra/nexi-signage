. "$PSScriptRoot\.env.ps1"
<#



#>

$dev = $env:CAVAAPPDEBUG

Write-Host "Policy Job starting"


$client_id = $env:CAVAAPPCLIENT_ID
$client_secret = $env:CAVAAPPCLIENT_SECRET
$client_domain = $env:CAVAAPPCLIENT_DOMAIN
$site = $env:CAVAAPPSITE

$CHECK_POLICY = $true
$PREFIX_ROOMPOLICY = "room-policy-"

$SUFFIX_GROUPALIAS = "-netsgroup"
$SUFFIX_GROUPNAME = " (Nets Group)"


$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/x-www-form-urlencoded")
$body = "grant_type=client_credentials&client_id=$client_id&client_secret=$client_secret&scope=https%3A//graph.microsoft.com/.default"

$response = Invoke-RestMethod "https://login.microsoftonline.com/$client_domain/oauth2/v2.0/token" -Method 'POST' -Headers $headers -body $body
$token = $response.access_token

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$headers.Add("Accept", "application/json")
$headers.Add("Authorization", "Bearer $token" )


Write-host "Connecting to Exchange Online"
$code = $env:AADPASSWORD
$username = $env:AADUSER 
$domain = $env:AADDOMAIN
 
$password = ConvertTo-SecureString $code -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

if ($Session -eq $null) {
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $psCred -Authentication Basic -AllowRedirection
    Import-PSSession $Session -DisableNameChecking #-CommandName New-MailContact
}

if (!$ExchangeCurrentRooms) {
    $ExchangeCurrentRoomGroups = @{}
    $ExchangeCurrentRooms = @{}
    
}
function CreateAlias($name) {
    return $name.ToLower().Replace(" ", "-").Replace(" ", "-").Replace(" ", "-").Replace(" ", "-").Replace(" ", "-").Replace(" ", "-")
}

function isMember($members, $roomSmtpAddress) {
    $found = $false
    foreach ($member in $members) {
        if ($members.PrimarySmtpAddress -eq $roomSmtpAddress) {
            $found = $true
        }
    }
    return $found
}

function LoadCurrentData() {
    if (($ExchangeCurrentRooms.Count -ne 0) -and ($ExchangeCurrentRoomGroups.Count -ne 0)) {
        return
    }
    write-host "Loading existing Room Lists from Exchange"
    $dls = get-distributiongroup -RecipientTypeDetails RoomList 
    foreach ($dl in $dls) {
        $members = get-distributiongroupmember $dl.identity
        $ExchangeCurrentRoomGroups.Add($dl.PrimarySmtpAddress, $members)
    
    }

    $mbxs = get-mailbox -RecipientTypeDetails:RoomMailbox
    foreach ($mbx in $mbxs) {
        $ExchangeCurrentRooms.Add($mbx.PrimarySmtpAddress, $mbx)
    }
    write-host "Done Loading existing Room Lists from Exchange"
}

function EnsureRoomList() {

    $roomGroups = Invoke-RestMethod ($site + '/Lists/Groups/items?$expand=fields&$top=5000' ) -Method 'GET' -Headers $headers 
    write-host $roomGroups.value.length "room Lists"
    
    $roomSites = Invoke-RestMethod  ($site + '/Lists/RoomSites/items?$expand=fields&$top=5000') -Method 'GET' -Headers $headers 
    write-host $roomSites.value.length "sites"

    $roomGroupsLookup = @{}  
    foreach ($roomGroup in $roomGroups.value) {
        if (!$roomGroupsLookup[$roomGroup.fields.SiteLookupId]) {
            $roomGroupsLookup.Add($roomGroup.fields.SiteLookupId.ToString(), $roomGroup)
        }
    
    }

    $roomSitesLookup = @{}
    
    $roomLists = @{} 
    

    
    
    # Like to have a distribution list for each site, 
    # unless the site has groups 
    
    foreach ($roomSite in $roomSites.value) {
        
        $roomSitesLookup.Add($roomSite.fields.Id.ToString(), $roomSite)
        
        if ( !$roomGroupsLookup[$roomSite.fields.Id]) {
            # If no groups exists for site , create a distribution list

            $alias = createAlias $roomSite.fields.Title
            $roomGroupSmtpAddress = "rooms-$alias@$domain"

            # Unless it already exists
            if (!$ExchangeCurrentRoomGroups.ContainsKey($roomGroupSmtpAddress)) {
                #TODO: Check presence of Key
                write-host "Creating RoomList for Site"
                New-DistributionGroup -PrimarySmtpAddress $roomGroupSmtpAddress -Name $roomSite.fields.Title  -RoomList 
            }
        }
        
    }

    foreach ($roomGroup in $roomGroup.value) {
        $alias = createAlias $roomGroup.fields.Title
        $roomGroupSmtpAddress = "rooms-$alias@$domain"
        
        if (!$ExchangeCurrentRoomGroups.ContainsKey($roomGroupSmtpAddress)) {
 
            # Unless it already exists
            write-host "Creating RoomList for Group"
            New-DistributionGroup -PrimarySmtpAddress $roomGroupSmtpAddress -Name $roomSite.fields.Title  -RoomList 
        
        }
    }
    
    
    $rooms = Invoke-RestMethod ($site + '/Lists/Rooms/items?$expand=fields&$top=5000') -Method 'GET' -Headers $headers 
    write-host $result.value.length "rooms"


    foreach ($room in $rooms.value) {
        if ($room.fields.GroupLookupId) {
            $alias = createAlias $roomGroupsLookup[$room.fields.GroupLookupId].fields.Title
            $roomGroupSmtpAddress = "rooms-$alias@$domain"
            $dl = $ExchangeCurrentRoomGroups[$roomGroupSmtpAddress]
            if ($dl) {
                if (!(isMember $dl $room.fields.Title)) {
                    Write-Host "Adding $($room.fields.Title) to $roomGroupSmtpAddress"
                    $res = Add-DistributionGroupMember -Identity $dl.Identity -Member $room.fields.Title -ErrorAction SilentlyContinue
                }
            }
        }
        else {
            if ($room.fields.SiteLookupId) {
                $alias = (createAlias $roomSitesLookup[$room.fields.SiteLookupId].fields.Title)
                $roomGroupSmtpAddress = "rooms-$alias@$domain"
                $dl = $ExchangeCurrentRoomGroups[$roomGroupSmtpAddress]
                if ($dl) {
                    if (!(isMember $dl $room.fields.Title)) {
                        Write-Host "Adding $($room.fields.Title) to $roomGroupSmtpAddress"
                        $res = Add-DistributionGroupMember -Identity $dl.Identity -Member $room.fields.Title -ErrorAction SilentlyContinue
                    }
                }
            }
            
        }
        
    }
    


}

function EnsurePolicies() {
   

    $url = $site + '/Lists/Rooms/items?$expand=fields&$top=5000' #&$filter=startswith(fields/Title,''dk-kb601-32b1'')'
    

    $result = Invoke-RestMethod ($url) -Method 'GET' -Headers $headers 
    write-host $result.value.length "rooms"

    $existingRooms = @{}
    foreach ($roommailbox in $roommailboxes) {
        
        $existingRooms.Add( $roommailbox.PrimarySmtpAddress, $roommailbox)
    
    }

    $number = 0
    foreach ($room in $result.value) {
        $number += 1
        write-host $number "Checking" $room.fields.Title
        $odata = $site + '/Lists/Room%20Policies/items/' + $room.fields.PolicyLookupId + '?$expand=fields'
        $policy = Invoke-RestMethod ($odata) -Method 'GET' -Headers $headers 

        $roomSmtpAddress = $room.fields.Title


        # $room.fields.Title   -ErrorAction SilentlyContinue $yy
        $existingRoom = $existingRooms[$room.fields.Title] 

        if (!$existingRoom ) {
            write-host "Creating new room mailbox"
            $yy = New-Mailbox -PrimarySmtpAddress $roomSmtpAddress -Name  $room.fields.Display_x0020_Name -DisplayName $room.fields.Display_x0020_Name -Room 


        }

        if ( $room.fields.Display_x0020_Name -ne $existingRoom.DisplayName) {
            write-host "Updating DisplayName" $roomSmtpAddress $room.fields.Display_x0020_Name
            Set-Mailbox  $roomSmtpAddress -DisplayName  $room.fields.Display_x0020_Name

        }


        if ($policy.fields.RestrictBooking) {
            $policyAlias = $PREFIX_ROOMPOLICY + (CreateAlias $policy.fields.Title) + $SUFFIX_GROUPALIAS
            $policyGroup = Get-DistributionGroup $policyAlias  -ErrorAction SilentlyContinue 
            $policySmtpAddress = "$PREFIX_ROOMPOLICY$alias$SUFFIX_GROUPALIAS@$domain"
            if (!$policyGroup) {
                New-UnifiedGroup -Alias $policyAlias  -PrimarySmtpAddress $policySmtpAddress -DisplayName "$displayName$SUFFIX_GROUPNAME"  -ManagedBy $owner
                #New-DistributionGroup -Alias $policyAlias  -PrimarySmtpAddress $policySmtpAddress -Name $policy.fields.Title 
            }
            if ($policy.fields.Owner1_x0020_Email) {
                Add-DistributionGroupMember $policySmtpAddress -Member $policy.fields.Owner1_x0020_Email  -ErrorAction SilentlyContinue 
            }
            if ($policy.fields.Owner2_x0020_Email) {
                Add-DistributionGroupMember $policySmtpAddress -Member $policy.fields.Owner2_x0020_Email  -ErrorAction SilentlyContinue 
            }
            
            
            if (!$policy.fields.Mailtip) {
                Set-Mailbox $roomSmtpAddress -MailTip "Booking restricted to members of $($policy.fields.Title)"
            }
            else {
                Set-Mailbox $roomSmtpAddress -MailTip $policy.fields.Mailtip
            }
            Set-CalendarProcessing $roomSmtpAddress -AllBookInPolicy:$false -BookInPolicy:"$policyAlias@$domain", "room-role-receptionist@$domain"
        }
        


        if ($CHECK_POLICY) {
            # Baseline
            $currentProcessingPolicy = Get-CalendarProcessing $room.fields.Title 

            # Set to $true is changes has been applied
            $needUpdate = $false

            if (!$currentProcessingPolicy.DeleteComments) {
                $needUpdate = $true
                Set-CalendarProcessing  $room.fields.Title  -DeleteComments:$false
            }




            # Result
            $currentProcessingPolicy = Get-CalendarProcessing $room.fields.Title 


            if ($needUpdate) {


                $statustext = ""

                $statustext += "DeleteComments;" + $currentProcessingPolicy.DeleteComments + "`r`n"
                $statustext += "AddOrganizerToSubject;" + $currentProcessingPolicy.AddOrganizerToSubject + "`r`n"


                $statustext += "AllBookInPolicy;" + $currentProcessingPolicy.AllBookInPolicy + "`r`n"
           
                $statustext += "AdditionalResponse;" + $currentProcessingPolicy.AdditionalResponse + "`r`n"
                $statustext += "AdditionalResponse;" + $currentProcessingPolicy.AdditionalResponse + "`r`n"
                $statustext += "BookingWindowInDays;" + $currentProcessingPolicy.BookingWindowInDays + "`r`n"
                $statustext += "BookInPolicy;" + $currentProcessingPolicy.BookInPolicy + "`r`n"
     
    


                $resultJSON = ConvertTo-Json -InputObject $statustext
                # write-host "----------------------------------"    
                # write-host "result"    
                # write-host $resultJSON 
                # write-host "----------------------------------"    
                $body = "{
            `n    `"fields`": {
            `n        `"Applied_x0020_Policies`": $resultJSON
            `n    }
            `n}"
    
                # write-host $body 
                $url = ($site + '/Lists/Rooms/items/' + $room.id)
      
                $response = Invoke-RestMethod $url -Method 'PATCH' -Headers $headers -Body $body
            
            } 
        }
    
    }
}

function EnsurePolicyGroups() {
   
    write-host "Checking Policy Groups" 
    $odata = $site + '/Lists/Room%20Policies/items?$expand=fields'
    $policies = Invoke-RestMethod ($odata) -Method 'GET' -Headers $headers 

    foreach ($policy in $policies.value) {
        if ($policy.fields.RestrictBooking) {
            $policyAlias = $PREFIX_ROOMPOLICY + (CreateAlias $policy.fields.Title) 
            $policyGroup = Get-DistributionGroup $policyAlias  -ErrorAction SilentlyContinue 
            $policySmtpAddress = "$policyAlias@$domain"
            $displayName = $policy.fields.Title
            if (!$policyGroup) {
                write-host "Creating Policy Group "  $policySmtpAddress
                New-DistributionGroup -Alias $policyAlias  -PrimarySmtpAddress $policySmtpAddress -Name $displayName  -CopyOwnerToMember -ManagedBy $policy.fields.Owner1_x0020_Email,"group-it@nets.eu"
            }
            if ($policy.fields.Owner1_x0020_Email) {
                Add-DistributionGroupMember $policySmtpAddress -Member $policy.fields.Owner1_x0020_Email  -ErrorAction SilentlyContinue 
            }
            if ($policy.fields.Owner2_x0020_Email) {
                Add-DistributionGroupMember $policySmtpAddress -Member $policy.fields.Owner2_x0020_Email  -ErrorAction SilentlyContinue 
            }
        }
    }

}




if (!$roommailboxes) {
    write-host "Caching rooms" 
    $roommailboxes = Get-Mailbox  -Filter  "RecipientTypeDetails -eq 'RoomMailbox'" 
}
else {

    write-host "Reading rooms from cache" 
}

EnsurePolicyGroups
LoadCurrentData
EnsureRoomList
EnsurePolicies

Write-Host "Done syncing"


if (!$dev -and $Session) {
    write-host "Closing session"
    Remove-PSSession $Session
    $Session = $null
  
}