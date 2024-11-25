 . "$PSScriptRoot\.env.ps1"
 $domain = $env:AADDOMAIN
 write-host $env:AADUSER
 
 write-host $domain
 
 $OutlookSession = $null
# return
 . "$PSScriptRoot\session-exchange-v2.ps1"
#return
 function AddLocation($displayName,$countryCode){
     $alias = $displayName.ToLower().Replace(" ","-").Replace(" ","-").Replace(" ","-")
    # Remove-DistributionGroup "rooms-$alias" -Confirm:$falseclear
     New-DistributionGroup -Alias "rooms-$alias"  -PrimarySmtpAddress "rooms-$alias@$domain" -Name $displayName  -RoomList 
 }

 function UpdateLocation($displayName,$countryCode){
     write-host "Updating location" $displayName
    $alias = $displayName.ToLower()
   # Remove-DistributionGroup "rooms-$alias" -Confirm:$falseclear
   Set-DistributionGroup "rooms-$alias@$domain" -Name $displayName  -RoomList 
}


 
 function AddRoomMailbox ($key,$name,$location,$capacity,$country,$videodevice){

    #  https://o365info.com/room-mailbox-powershell-commands/


    $alias = "room-$key" 
    # Remove-Mailbox "room-$key@$domain" -Confirm:$false   ## !! Doesn't work on rooms
    New-Mailbox  -Alias $alias -PrimarySmtpAddress "room-$key@$domain" -Name $name -DisplayName $name -Room -ResourceCapacity  $capacity 
    Add-DistributionGroupMember -Identity "rooms-$location" -Member $alias
    Set-Place  $alias   -Capacity $capacity -CountryOrRegion $country    -VideoDeviceName $videodevice   -Building $location
#    Set-CalendarProcessing $alias -AllBookInPolicy: $False -BookInPolicy:"room-role-pa@$domain","room-role-receptionist@$domain" -AddOrganizerToSubject $True
#     Set-Mailbox $alias -MailTip "Room can only be reserved by PA's and receptionists"
     Add-MailBoxPermission $alias -User "room-role-receptionist@$domain" -AccessRights FullAccess
     Add-RecipientPermission $alias -Trustee "room-role-receptionist@$domain" -AccessRights SendAs -Confirm:$False 


}


function UpdateRoomMailbox ($key,$group1,$group2){

    $alias = "room-$key" 
    if ("$group1 " -ne $group2 ){
        write-host "adding to secondary group" $key $group1 $group2
        $groupAlias = $group2.replace(" ","-").replace(" ","-").replace(" ","-").replace(" ","-")
        Add-DistributionGroupMember -Identity "rooms-$groupAlias" -Member $alias
    }
    else 
    {
        write-host "No secondary group" $key $group1
    }

}

UpdateLocation "DK-KB601" "DK"

return

AddRoomMailbox "hr-virtual_room_1" "HR-Virtual_Room_1 (Only CEO)" "HR" 100 hr
AddRoomMailbox "hr-virtual_room_2" "HR-Virtual_Room_2" "HR"  100 hr
AddRoomMailbox "hr-virtual_room_3" "HR-Virtual_Room_3" "HR" 100 hr
AddRoomMailbox "hr-virtual_room_4" "HR-Virtual_Room_4" "HR"   100 hr
AddRoomMailbox "hr-virtual_room_5" "HR-Virtual_Room_5" "HR"   100 hr
return

AddRoomMailbox "hr-lu23-cockpit" "HR-LU23-Cockpit Video (2)" "HR-LU23" 2 hr Video
AddRoomMailbox "hr-lu23-inserter_room" "HR-LU23-Inserter_room Video (20)" "HR-LU23" 20 hr Video
AddRoomMailbox "hr-rc50-infrastructure_room" "HR-RC50-Infrastructure_Room Video (10)" "HR-RC50" 10 hr Video
AddRoomMailbox "si-pu14-pisarna_b226" "SI-PU14-Pisarna_B226 Video (10)" "SI-PU14" 10 si Video
AddRoomMailbox "si-pu14-sejna_soba" "SI-PU14-Sejna_soba Video (15)" "SI-PU14" 15 si Video




return
UpdateRoomMailbox "dk-en1-0.06" "DK-EN1" "DK-EN1 " 
UpdateRoomMailbox "dk-en1-1.05" "DK-EN1" "DK-EN1 " 
UpdateRoomMailbox "dk-en1-1.14" "DK-EN1" "DK-EN1 " 
UpdateRoomMailbox "dk-en1-1.51" "DK-EN1" "DK-EN1 " 
UpdateRoomMailbox "dk-en1-1.52" "DK-EN1" "DK-EN1 " 
UpdateRoomMailbox "dk-kb601-21a2" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-kb601-21a3" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-21a4" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-21a5" "DK-KB601" "DK-KB601 Project rooms" 
UpdateRoomMailbox "dk-kb601-21a6" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-21c1" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-21c2" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-21c3" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-21c4" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-21d1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-21d2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-21d3" "DK-KB601" "DK-KB601 Project rooms" 
UpdateRoomMailbox "dk-kb601-21d4" "DK-KB601" "DK-KB601 Project rooms" 
UpdateRoomMailbox "dk-kb601-21e1" "DK-KB601" "DK-KB601 Project rooms" 
UpdateRoomMailbox "dk-kb601-22a1" "DK-KB601" "DK-KB601 Project rooms" 
UpdateRoomMailbox "dk-kb601-22a2" "DK-KB601" "DK-KB601 Project rooms" 
UpdateRoomMailbox "dk-kb601-22a3" "DK-KB601" "DK-KB601 Project rooms" 
UpdateRoomMailbox "dk-kb601-22a4" "DK-KB601" "DK-KB601 Project rooms" 
UpdateRoomMailbox "dk-kb601-22b1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-22b2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-22c1" "DK-KB601" "DK-KB601 " 
UpdateRoomMailbox "dk-kb601-22c2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-22c3" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-22d1" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-22d2" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-22d3" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-22d4" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-22e1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-22e2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-22a1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-23a2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-23a3" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-23a4" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-23b1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-23b2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-23c1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-23c2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-23c3" "DK-KB601" "DK-KB601 ExCo rooms" 
UpdateRoomMailbox "dk-kb601-23d1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-23d2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-23e1" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-kb601-23e2" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-kb601-31m1" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-kb601-31m10" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m12" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m13" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m14" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m15" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m16" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m17" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m11" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-kb601-31m18" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-kb601-31m2" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m3" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m4" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m5" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m6" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-31m7" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-kb601-31m8" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-kb601-31m9" "DK-KB601" "DK-KB601 External meetings" 
UpdateRoomMailbox "dk-kb601-32a2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-32a3" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-32b1" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-kb601-32b2" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-32b3" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-32b4" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-32b5" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-32b6" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-32b7" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-32b8" "DK-KB601" "DK-KB601 ExCo rooms" 
UpdateRoomMailbox "dk-kb601-32c1" "DK-KB601" "DK-KB601 ExCo rooms" 
UpdateRoomMailbox "dk-kb601-32c2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-32c3" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-32c4" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-33a1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-33a2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-33b1" "DK-KB601" "DK-KB601 ExCo rooms" 
UpdateRoomMailbox "dk-kb601-33b2" "DK-KB601" "DK-KB601 ExCo rooms" 
UpdateRoomMailbox "dk-kb601-33b3" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-33b4" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-33c1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-33c2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-33d1" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-42a1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-42a2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-42a3" "DK-KB601" "DK-KB601 ExCo rooms" 
UpdateRoomMailbox "dk-kb601-42b1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-42b2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-42b3" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-42b4" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-42c1" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-42c2" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-42c3" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-42d1" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-42d2" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-42d3" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-43a1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-43a2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-43b1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-43b2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-43c1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-43c2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-43c3" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-43c4" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-43c5" "DK-KB601" "DK-KB601 Internal meetings" 
UpdateRoomMailbox "dk-kb601-43c6" "DK-KB601" "DK-KB601 Project rooms" 
UpdateRoomMailbox "dk-kb601-43d1" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-43d2" "DK-KB601" "DK-KB601 Flex rooms" 
UpdateRoomMailbox "dk-kb601-43d3" "DK-KB601" "DK-KB601 ExCo rooms" 
UpdateRoomMailbox "" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "" "DK-KB601" "DK-KB601 Special rooms" 
UpdateRoomMailbox "dk-lv24-1_jorden_3" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-1_jorden_5" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-1_jorden_8" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-1_karlsvognen_8" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-1_orion_4" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-m1" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-m1" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-m1" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-m1" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-lille-bjoern" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-lv24-store-bjoern" "DK-LV24" "DK-LV24 " 
UpdateRoomMailbox "dk-vh-1" "DK-VH" "DK-VH " 
UpdateRoomMailbox "dk-vh-2" "DK-VH" "DK-VH " 
UpdateRoomMailbox "dk-vh-m1" "DK-VH" "DK-VH " 
UpdateRoomMailbox "dk-vh-b3" "DK-VH" "DK-VH " 
UpdateRoomMailbox "dk-vh-5" "DK-VH" "DK-VH " 
UpdateRoomMailbox "fi-t21-ms-showroom" "FI-T21" "FI-T21 Special rooms" 
UpdateRoomMailbox "fi-t21-4-c4224-vallisaari" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-4-c4230-lonna" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-4-c4243-villinki" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-4-c4275-harmaja" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-4-d4426-haapasaari" "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-4-m1" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-4-m2" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-4-m3" "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-5-c5210-vartsala " "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-5-c5224-vasikkasaari" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-5-c5230-öölanti" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-5-c5274-gotlanti" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-5-m4" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-5-m5" "FI-T21" "FI-T21 " 
UpdateRoomMailbox "fi-t21-5-m6" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-b6474-suomenlinna " "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-c6212-vaindloo " "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-6-c6226-seurasaari" "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-6-c6230-kustaanmiekk" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-c6243-sarkka" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-c6270-uunisaari" "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-6-c6274-sappi" "FI-T21" "FI-T21 Special rooms" 
UpdateRoomMailbox "fi-t21-6-m7" "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-6-m8" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-m9" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-canteen" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-nettverket" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-pki" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-teknologi" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "fi-t21-6-arkivet" "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-7-c7243-kustavi" "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-7-c7274-otava" "FI-T21" "FI-T21 Internal meetings" 
UpdateRoomMailbox "fi-t21-7-avtalegiro" "FI-T21" "FI-T21 External meetings" 
UpdateRoomMailbox "hr-rc50-blue" "HR-RC50" "HR-RC50 " 
UpdateRoomMailbox "hr-rc50-bid" "HR-RC50" "HR-RC50 " 
UpdateRoomMailbox "hr-rc50-green" "HR-RC50" "HR-RC50 " 
UpdateRoomMailbox "hr-rc50-grey" "HR-RC50" "HR-RC50 " 
UpdateRoomMailbox "hr-rc50-orange" "HR-RC50" "HR-RC50 " 
UpdateRoomMailbox "hr-rc50-purple" "HR-RC50" "HR-RC50 " 
UpdateRoomMailbox "hr-rc50-red" "HR-RC50" "HR-RC50 " 
UpdateRoomMailbox "hr-rc50-white" "HR-RC50" "HR-RC50 " 
UpdateRoomMailbox "hr-rc50-yellow" "HR-RC50" "HR-RC50 " 
UpdateRoomMailbox "no-hm54-k0-m1" "NO-HM54" "NO-HM54 Special rooms" 
UpdateRoomMailbox "no-hm54-k0-m2" "NO-HM54" "NO-HM54 External roomgs" 
UpdateRoomMailbox "no-hm54-k0-m3" "NO-HM54" "NO-HM54 External roomgs" 
UpdateRoomMailbox "no-hm54-k0-m4" "NO-HM54" "NO-HM54 External roomgs" 
UpdateRoomMailbox "no-hm54-k0-m5" "NO-HM54" "NO-HM54 External roomgs" 
UpdateRoomMailbox "no-hm54-k0-m6" "NO-HM54" "NO-HM54 External meetings" 
UpdateRoomMailbox "no-hm54-k0-m7" "NO-HM54" "NO-HM54 External meetings" 
UpdateRoomMailbox "no-hm54-k0-m8" "NO-HM54" "NO-HM54 Special rooms" 
UpdateRoomMailbox "no-hm54-k0-m9" "NO-HM54" "NO-HM54 External roomgs" 
UpdateRoomMailbox "no-hm54-k1-canteen" "NO-HM54" "NO-HM54 Special rooms" 
UpdateRoomMailbox "no-hm54-k1-nettverket" "NO-HM54" "NO-HM54 External meetings" 
UpdateRoomMailbox "no-hm54-k1-pki" "NO-HM54" "NO-HM54 External meetings" 
UpdateRoomMailbox "no-hm54-k1-teknologi" "NO-HM54" "NO-HM54 External meetings" 
UpdateRoomMailbox "no-hm54-k2-arkivet" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-k3-avtalegiro" "NO-HM54" "NO-HM54 Project rooms" 
UpdateRoomMailbox "no-hm54-k4-bid" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-k4-signatur" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-k4-tillitstjenester" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d2-n-boersen" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d2-n-brynhild" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d2-n-katedralen" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d2-s-hubble" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d2-s-jupiter" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d2-s-mercur" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d2-s-pluto" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d2-s-saturn" "NO-HM54" "NO-HM54 Project rooms" 
UpdateRoomMailbox "no-hm54-d3-n-odin" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d3-n-valhall" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d3-n-naasgard" "NO-HM54" "NO-HM54 Project rooms" 
UpdateRoomMailbox "no-hm54-d3-s-genesis" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d3-s-java" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d3-s-oracle" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d3-s-pojo" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "no-hm54-d3-s-scrum room" "NO-HM54" "NO-HM54 Special meetings" 
UpdateRoomMailbox "no-hm54-d3-s-stay" "NO-HM54" "NO-HM54 Internal meetings" 
UpdateRoomMailbox "" "NO-HM54" "NO-HM54 Special rooms" 
UpdateRoomMailbox "no-ho1-1_jupiter" "NO-HO1" "NO-HO1 External meetings" 
UpdateRoomMailbox "no-ho1-1_merkur" "NO-HO1" "NO-HO1 External Meetings" 
UpdateRoomMailbox "no-ho1-1_saturn" "NO-HO1" "NO-HO1 External Meetings" 
UpdateRoomMailbox "no-ho1-1_tellus" "NO-HO1" "NO-HO1 External Meetings" 
UpdateRoomMailbox "no-ho1-capella" "NO-HO1" "NO-HO1 Internal meetings" 
UpdateRoomMailbox "no-ho1-helios" "NO-HO1" "NO-HO1 Special rooms" 
UpdateRoomMailbox "no-ho1-mars" "NO-HO1" "NO-HO1 Internal meetings" 
UpdateRoomMailbox "no-ho1-neptun" "NO-HO1" "NO-HO1 Internal meetings" 
UpdateRoomMailbox "no-ho1-nova" "NO-HO1" "NO-HO1 Internal meetings" 
UpdateRoomMailbox "no-ho1-pandor" "NO-HO1" "NO-HO1 Internal meetings" 
UpdateRoomMailbox "no-ho1-rigel" "NO-HO1" "NO-HO1 Internal meetings" 
UpdateRoomMailbox "no-ho1-uranus" "NO-HO1" "NO-HO1 Internal meetings" 
UpdateRoomMailbox "se-lp11-6-all-staff" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-commitment" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-diversity" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-excel" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-explore" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-focus" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-growth" "SE-LP11" "SE-LP11 External Meetings" 
UpdateRoomMailbox "se-lp11-6-headquarters" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-idea" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-loyalty" "SE-LP11" "SE-LP11 External Meetings" 
UpdateRoomMailbox "se-lp11-6-respect" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-solution" "SE-LP11" "SE-LP11 Internal Meetings" 
UpdateRoomMailbox "se-lp11-6-together" "SE-LP11" "SE-LP11 External Meetings" 
UpdateRoomMailbox "se-lp11-7-vision" "SE-LP11" "SE-LP11 Internal Meetings" 

return 
# AddLocation "DK-EN1" "DK"

AddLocation "DK-KB601 Flex rooms" "DK"
AddLocation "DK-KB601 Project rooms" "DK"
AddLocation "DK-KB601 Internal meetings" "DK"
AddLocation "DK-KB601 External meetings" "DK"
AddLocation "DK-KB601 ExCo rooms" "DK"
AddLocation "DK-KB601 Special rooms" "DK"


AddLocation "NO-HM54 Project rooms" "NO"
AddLocation "NO-HM54 Internal meetings" "NO"
AddLocation "NO-HM54 External meetings" "NO"
AddLocation "NO-HM54 Special rooms" "NO"

AddLocation "FI-T21 Internal meetings" "FI"
AddLocation "FI-T21 External meetings" "FI"
AddLocation "FI-T21 Special rooms" "FI"


AddLocation "NO-HO1 Internal meetings" "NO"
AddLocation "NO-HO1 External meetings" "NO"

AddLocation "SE-LP11 Internal meetings" "DK"
AddLocation "SE-LP11 External meetings" "DK"

AddLocation "HR-LU23" "HR"

return

# UpdateLocation "DK-KB601" "DK"
#return
# AddLocation "DK-EN1" "DK"
# #return
# AddLocation "DK-KB601" "DK"
# AddLocation "DK-LV24" "DK"
# AddLocation "DK-VH" "DK"
# AddLocation "FI-T21" "FI"
# AddLocation "HR-RC50" "HR"
# AddLocation "NO-HM54" "NO"
# AddLocation "NO-HO1" "NO"
# AddLocation "SE-LP11" "SE"
# AddLocation "SI-PU14" "SI"
# AddLocation "SI-SU24" "SI"


AddRoomMailbox "dk-en1-0.06" "DK-EN1-0.06 Video (8)" "DK-EN1" 8 dk Video

AddRoomMailbox "dk-en1-1.05" "DK-EN1-1.05 Video (6)" "DK-EN1" 6 dk Video
AddRoomMailbox "dk-en1-1.14" "DK-EN1-1.14 (4)" "DK-EN1" 4 dk 
AddRoomMailbox "dk-en1-1.51" "DK-EN1-1.51 (8)" "DK-EN1" 8 dk 
AddRoomMailbox "dk-en1-1.52" "DK-EN1-1.52 (20)" "DK-EN1" 20 dk 
AddRoomMailbox "dk-kb601-2.1-a.2" "DK-KB601-2.1-A.2 Video (16)" "DK-KB601" 16 dk Video
AddRoomMailbox "dk-kb601-2.1-a.3" "DK-KB601-2.1-A.3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.1-a.4" "DK-KB601-2.1-A.4 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-2.1-a.5" "DK-KB601-2.1-A.5 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-2.1-a.6" "DK-KB601-2.1-A.6 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.1-c.1" "DK-KB601-2.1-C.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.1-c.2" "DK-KB601-2.1-C.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.1-c.3" "DK-KB601-2.1-C.3 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-2.1-c.4" "DK-KB601-2.1-C.4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.1-d.1" "DK-KB601-2.1-D.1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-2.1-d.2" "DK-KB601-2.1-D.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.1-d.3" "DK-KB601-2.1-D.3 Video (20)" "DK-KB601" 20 dk Video
AddRoomMailbox "dk-kb601-2.1-d.4" "DK-KB601-2.1-D.4 Video (20)" "DK-KB601" 20 dk Video
AddRoomMailbox "dk-kb601-2.1-e.1" "DK-KB601-2.1-E.1 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-2.2-a.1" "DK-KB601-2.2-A.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.2-a.2" "DK-KB601-2.2-A.2 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-2.2-a.3" "DK-KB601-2.2-A.3 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-2.2-a.4" "DK-KB601-2.2-A.4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.2-b.1" "DK-KB601-2.2-B.1 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-2.2-b.2" "DK-KB601-2.2-B.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.2-c.1" "DK-KB601-2.2-C.1 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-2.2-c.2" "DK-KB601-2.2-C.2 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-2.2-c.3" "DK-KB601-2.2-C.3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.2-d.1" "DK-KB601-2.2-D.1 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-2.2-d.2" "DK-KB601-2.2-D.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.2-d.3" "DK-KB601-2.2-D.3 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-2.2-d.4" "DK-KB601-2.2-D.4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.2-e.1" "DK-KB601-2.2-E.1 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-2.2-e.2" "DK-KB601-2.2-E.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.2-a.1" "DK-KB601-2.2-A.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.3-a.2" "DK-KB601-2.3-A.2 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-2.3-a.3" "DK-KB601-2.3-A.3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.3-a.4" "DK-KB601-2.3-A.4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.3-b.1" "DK-KB601-2.3-B.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.3-b.2" "DK-KB601-2.3-B.2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-2.3-c.1" "DK-KB601-2.3-C.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-2.3-c.2" "DK-KB601-2.3-C.2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-2.3-c.3" "DK-KB601-2.3-C.3 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-2.3-d.1" "DK-KB601-2.3-D.1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-2.3-d.2" "DK-KB601-2.3-D.2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-2.3-e.1" "DK-KB601-2.3-E.1 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-2.3-e.2" "DK-KB601-2.3-E.2 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-3.1-m.1" "DK-KB601-3.1-M.1 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-3.1-m.1" "DK-KB601-3.1-M.1 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-3.1-m.1" "DK-KB601-3.1-M.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-3.1-m.1" "DK-KB601-3.1-M.1 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-3.1-m.1" "DK-KB601-3.1-M.1 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-3.1-m.2" "DK-KB601-3.1-M.2 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-3.1-m.3" "DK-KB601-3.1-M.3 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-3.1-m.4" "DK-KB601-3.1-M.4 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-3.1-m.5" "DK-KB601-3.1-M.5 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-3.1-m.6" "DK-KB601-3.1-M.6 Video (24)" "DK-KB601" 24 dk Video
AddRoomMailbox "dk-kb601-3.1-m.7" "DK-KB601-3.1-M.7 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-3.1-m.8" "DK-KB601-3.1-M.8 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-3.1-m.9" "DK-KB601-3.1-M.9 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-3.1-a.2" "DK-KB601-3.1-A.2 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-3.1-a.3" "DK-KB601-3.1-A.3 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-3.1-b.1" "DK-KB601-3.1-B.1 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-3.1-b.2" "DK-KB601-3.1-B.2 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-3.1-b.3" "DK-KB601-3.1-B.3 Video (24)" "DK-KB601" 24 dk Video
AddRoomMailbox "dk-kb601-3.2-b.4" "DK-KB601-3.2-B.4 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-3.2-b.5" "DK-KB601-3.2-B.5 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-3.2-b.6" "DK-KB601-3.2-B.6 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-3.2-b.7" "DK-KB601-3.2-B.7 (6)" "DK-KB601" 6 dk 
AddRoomMailbox "dk-kb601-3.2-b.8" "DK-KB601-3.2-B.8 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-3.2-c.1" "DK-KB601-3.2-C.1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-3.2-c.2" "DK-KB601-3.2-C.2 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-3.2-c.3" "DK-KB601-3.2-C.3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-3.2-c.4" "DK-KB601-3.2-C.4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-3.2-a.1" "DK-KB601-3.2-A.1 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-3.2-a.2" "DK-KB601-3.2-A.2 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-3.2-b.1" "DK-KB601-3.2-B.1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-3.2-b.2" "DK-KB601-3.2-B.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-3.2-b.3" "DK-KB601-3.2-B.3 Video (16)" "DK-KB601" 16 dk Video
AddRoomMailbox "dk-kb601-3.3-b.4" "DK-KB601-3.3-B.4 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-3.3-c.1" "DK-KB601-3.3-C.1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-3.3-c.2" "DK-KB601-3.3-C.2 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-3.3-d.1" "DK-KB601-3.3-D.1 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-3.3-a.1" "DK-KB601-3.3-A.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-3.3-a.2" "DK-KB601-3.3-A.2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-3.3-a.3" "DK-KB601-3.3-A.3 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-3.3-b.1" "DK-KB601-3.3-B.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-3.3-b.2" "DK-KB601-3.3-B.2 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-4.2-b.4" "DK-KB601-4.2-B.4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.2-c.1" "DK-KB601-4.2-C.1 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-4.2-c.2" "DK-KB601-4.2-C.2 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-4.2-c.3" "DK-KB601-4.2-C.3 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-4.2-d.1" "DK-KB601-4.2-D.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.2-d.2" "DK-KB601-4.2-D.2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-4.2-d.3" "DK-KB601-4.2-D.3 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-4.2-a.1" "DK-KB601-4.2-A.1 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-4.2-a.2" "DK-KB601-4.2-A.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.2-b.1" "DK-KB601-4.2-B.1 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-4.2-b.2" "DK-KB601-4.2-B.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.2-c.1" "DK-KB601-4.2-C.1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.2-c.2" "DK-KB601-4.2-C.2 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-4.3-c.3" "DK-KB601-4.3-C.3 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-4.3-c.4" "DK-KB601-4.3-C.4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.3-c.5" "DK-KB601-4.3-C.5 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-4.3-c.6" "DK-KB601-4.3-C.6 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.3-d.1" "DK-KB601-4.3-D.1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-4.3-d.2" "DK-KB601-4.3-D.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.3-d.3" "DK-KB601-4.3-D.3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.3-4.3.c.4" "DK-KB601-4.3-4.3.C.4 (3)" "DK-KB601" 3 dk 
AddRoomMailbox "dk-kb601-4.3-4.3.c.5" "DK-KB601-4.3-4.3.C.5 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.3-4.3.c.6" "DK-KB601-4.3-4.3.C.6 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-4.3-4.3.d.1" "DK-KB601-4.3-4.3.D.1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-4.3-4.3.d.2" "DK-KB601-4.3-4.3.D.2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-4.3-4.3.d.3" "DK-KB601-4.3-4.3.D.3 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-lv24-1_jorden_3" "DK-LV24-1_JORDEN_3 Video (6)" "DK-LV24" 6 dk Video
AddRoomMailbox "dk-lv24-1_jorden_5" "DK-LV24-1_JORDEN_5 Video (5)" "DK-LV24" 5 dk Video
AddRoomMailbox "dk-lv24-1_jorden_8" "DK-LV24-1_JORDEN_8 Video (5)" "DK-LV24" 5 dk Video
AddRoomMailbox "dk-lv24-1_karlsvognen_8" "DK-LV24-1_KARLSVOGNEN_8 Video (8)" "DK-LV24" 8 dk Video
AddRoomMailbox "dk-lv24-1_orion_4" "DK-LV24-1_ORION_4 Video (4)" "DK-LV24" 4 dk Video
AddRoomMailbox "dk-lv24-m.1" "DK-LV24-M.1 Video (6)" "DK-LV24" 6 dk Video
AddRoomMailbox "dk-lv24-m.1" "DK-LV24-M.1 Video (6)" "DK-LV24" 6 dk Video
AddRoomMailbox "dk-lv24-m.1" "DK-LV24-M.1 (8)" "DK-LV24" 8 dk 
AddRoomMailbox "dk-lv24-m.1" "DK-LV24-M.1 Video (6)" "DK-LV24" 6 dk Video
AddRoomMailbox "dk-lv24-lille-bjoern" "DK-LV24-Lille-Bjoern Video (4)" "DK-LV24" 4 dk Video
AddRoomMailbox "dk-lv24-store-bjoern" "DK-LV24-Store-Bjoern Video (8)" "DK-LV24" 8 dk Video
AddRoomMailbox "dk-vh-1" "DK-VH-1 (8)" "DK-VH" 8 dk 
AddRoomMailbox "dk-vh-2" "DK-VH-2 (2)" "DK-VH" 2 dk 
AddRoomMailbox "dk-vh-m.1" "DK-VH-M.1 (2)" "DK-VH" 2 dk 
AddRoomMailbox "dk-vh-b.3" "DK-VH-B.3 (2)" "DK-VH" 2 dk 
AddRoomMailbox "dk-vh-5" "DK-VH-5 (2)" "DK-VH" 2 dk 
AddRoomMailbox "fi-t21-ms showroom" "FI-T21-MS Showroom (4)" "FI-T21" 4 fi 
AddRoomMailbox "fi-t21-4-c4224-vallisaari" "FI-T21-4-C4224-Vallisaari Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-4-c4230-lonna" "FI-T21-4-C4230-Lonna (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-4-c4243-villinki" "FI-T21-4-C4243-Villinki (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-4-c4275-harmaja" "FI-T21-4-C4275-Harmaja Video (5)" "FI-T21" 5 fi Video
AddRoomMailbox "fi-t21-4-d4426-haapasaari" "FI-T21-4-D4426-Haapasaari (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-4-m1" "FI-T21-4-M1 Video (13)" "FI-T21" 13 fi Video
AddRoomMailbox "fi-t21-4-m2" "FI-T21-4-M2 (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-4-m3" "FI-T21-4-M3 (12)" "FI-T21" 12 fi 
AddRoomMailbox "fi-t21-5-c5210-vartsala " "FI-T21-5-C5210-Vartsala  Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-5-c5224-vasikkasaari" "FI-T21-5-C5224-Vasikkasaari Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-5-c5230-öölanti" "FI-T21-5-C5230-Öölanti (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-5-c5274-gotlanti" "FI-T21-5-C5274-Gotlanti (16)" "FI-T21" 16 fi 
AddRoomMailbox "fi-t21-5-m4" "FI-T21-5-M4 Video (9)" "FI-T21" 9 fi Video
AddRoomMailbox "fi-t21-5-m5" "FI-T21-5-M5 Video (8)" "FI-T21" 8 fi Video
AddRoomMailbox "fi-t21-5-m6" "FI-T21-5-M6 Video (12)" "FI-T21" 12 fi Video
AddRoomMailbox "fi-t21-6-b6474-suomenlinna " "FI-T21-6-B6474-Suomenlinna  Video (22)" "FI-T21" 22 fi Video
AddRoomMailbox "fi-t21-6-c6212-vaindloo " "FI-T21-6-C6212-Vaindloo  Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-6-c6226-seurasaari" "FI-T21-6-C6226-Seurasaari (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-6-c6230-kustaanmiekk" "FI-T21-6-C6230-Kustaanmiekk (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-6-c6243-särkkä" "FI-T21-6-C6243-Särkkä Video (13)" "FI-T21" 13 fi Video
AddRoomMailbox "fi-t21-6-c6270-uunisaari" "FI-T21-6-C6270-Uunisaari (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-6-c6274-säppi" "FI-T21-6-C6274-Säppi (1)" "FI-T21" 1 fi 
AddRoomMailbox "fi-t21-6-m7" "FI-T21-6-M7 (9)" "FI-T21" 9 fi 
AddRoomMailbox "fi-t21-6-m8" "FI-T21-6-M8 (9)" "FI-T21" 9 fi 
AddRoomMailbox "fi-t21-6-m9" "FI-T21-6-M9 Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-6-canteen" "FI-T21-6-Canteen Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-6-nettverket" "FI-T21-6-Nettverket Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-6-pki" "FI-T21-6-PKI Video (5)" "FI-T21" 5 fi Video
AddRoomMailbox "fi-t21-6-teknologi" "FI-T21-6-Teknologi Video (5)" "FI-T21" 5 fi Video
AddRoomMailbox "fi-t21-6-arkivet" "FI-T21-6-Arkivet (9)" "FI-T21" 9 fi 
AddRoomMailbox "fi-t21-7-c7243-kustavi" "FI-T21-7-C7243-Kustavi (12)" "FI-T21" 12 fi 
AddRoomMailbox "fi-t21-7-c7274-otava" "FI-T21-7-C7274-Otava (15)" "FI-T21" 15 fi 
AddRoomMailbox "fi-t21-7-avtalegiro" "FI-T21-7-Avtalegiro Video (16)" "FI-T21" 16 fi Video
AddRoomMailbox "hr-rc50-blue" "HR-RC50-Blue Video (7)" "HR-RC50" 7 hr Video
AddRoomMailbox "hr-rc50-bid" "HR-RC50-BID Video (7)" "HR-RC50" 7 hr Video
AddRoomMailbox "hr-rc50-green" "HR-RC50-Green Video (8)" "HR-RC50" 8 hr Video
AddRoomMailbox "hr-rc50-grey" "HR-RC50-Grey Video (6)" "HR-RC50" 6 hr Video
AddRoomMailbox "hr-rc50-orange" "HR-RC50-Orange Video (7)" "HR-RC50" 7 hr Video
AddRoomMailbox "hr-rc50-purple" "HR-RC50-Purple Video (14)" "HR-RC50" 14 hr Video
AddRoomMailbox "hr-rc50-red" "HR-RC50-Red Video (5)" "HR-RC50" 5 hr Video
AddRoomMailbox "hr-rc50-white" "HR-RC50-White Video (20)" "HR-RC50" 20 hr Video
AddRoomMailbox "hr-rc50-yellow" "HR-RC50-Yellow Video (12)" "HR-RC50" 12 hr Video
AddRoomMailbox "no-hm54-k0-m1" "NO-HM54-K0-M1 (44)" "NO-HM54" 44 no 
AddRoomMailbox "no-hm54-k0-m2" "NO-HM54-K0-M2 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k0-m3" "NO-HM54-K0-M3 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k0-m4" "NO-HM54-K0-M4 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k0-m5" "NO-HM54-K0-M5 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k0-m6" "NO-HM54-K0-M6 Video (8)" "NO-HM54" 8 no Video
AddRoomMailbox "no-hm54-k0-m7" "NO-HM54-K0-M7 Video (10)" "NO-HM54" 10 no Video
AddRoomMailbox "no-hm54-k0-m8" "NO-HM54-K0-M8 (24)" "NO-HM54" 24 no 
AddRoomMailbox "no-hm54-k0-m9" "NO-HM54-K0-M9 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k1-canteen" "NO-HM54-K1-Canteen (150)" "NO-HM54" 150 no 
AddRoomMailbox "no-hm54-k1-nettverket" "NO-HM54-K1-Nettverket Video (16)" "NO-HM54" 16 no Video
AddRoomMailbox "no-hm54-k1-pki" "NO-HM54-K1-PKI Video (12)" "NO-HM54" 12 no Video
AddRoomMailbox "no-hm54-k1-teknologi" "NO-HM54-K1-Teknologi Video (14)" "NO-HM54" 14 no Video
AddRoomMailbox "no-hm54-k2-arkivet" "NO-HM54-K2-Arkivet Video (16)" "NO-HM54" 16 no Video
AddRoomMailbox "no-hm54-k3-avtalegiro" "NO-HM54-K3-Avtalegiro Video (8)" "NO-HM54" 8 no Video
AddRoomMailbox "no-hm54-k4-bid" "NO-HM54-K4-BID Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-k4-signatur" "NO-HM54-K4-Signatur (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k4-tillitstjenester" "NO-HM54-K4-Tillitstjenester (18)" "NO-HM54" 18 no 
AddRoomMailbox "no-hm54-d2-n-boersen" "NO-HM54-D2-N-Boersen Video (8)" "NO-HM54" 8 no Video
AddRoomMailbox "no-hm54-d2-n-brynhild" "NO-HM54-D2-N-Brynhild Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d2-n-katedralen" "NO-HM54-D2-N-Katedralen (12)" "NO-HM54" 12 no 
AddRoomMailbox "no-hm54-d2-s-hubble" "NO-HM54-D2-S-Hubble Video (8)" "NO-HM54" 8 no Video
AddRoomMailbox "no-hm54-d2-s-jupiter" "NO-HM54-D2-S-Jupiter (14)" "NO-HM54" 14 no 
AddRoomMailbox "no-hm54-d2-s-mercur" "NO-HM54-D2-S-Mercur Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d2-s-pluto" "NO-HM54-D2-S-Pluto Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d2-s-saturn" "NO-HM54-D2-S-Saturn Video (14)" "NO-HM54" 14 no Video
AddRoomMailbox "no-hm54-d3-n-odin" "NO-HM54-D3-N-Odin Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d3-n-valhall" "NO-HM54-D3-N-Valhall (14)" "NO-HM54" 14 no 
AddRoomMailbox "no-hm54-d3-n-naasgard" "NO-HM54-D3-N-Naasgard Video (14)" "NO-HM54" 14 no Video
AddRoomMailbox "no-hm54-d3-s-genesis" "NO-HM54-D3-S-Genesis Video (1)" "NO-HM54" 1 no Video
AddRoomMailbox "no-hm54-d3-s-java" "NO-HM54-D3-S-Java (14)" "NO-HM54" 14 no 
AddRoomMailbox "no-hm54-d3-s-oracle" "NO-HM54-D3-S-Oracle Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d3-s-pojo" "NO-HM54-D3-S-Pojo Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d3-s-scrum room" "NO-HM54-D3-S-Scrum room Video (18)" "NO-HM54" 18 no Video
AddRoomMailbox "no-hm54-d3-s-stay" "NO-HM54-D3-S-Stay (14)" "NO-HM54" 14 no 
AddRoomMailbox "no-ho1-1_jupiter" "NO-HO1-1_Jupiter Video (10)" "NO-HO1" 10 no Video
AddRoomMailbox "no-ho1-1_merkur" "NO-HO1-1_Merkur (10)" "NO-HO1" 10 no 
AddRoomMailbox "no-ho1-1_saturn" "NO-HO1-1_Saturn (10)" "NO-HO1" 10 no 
AddRoomMailbox "no-ho1-1_tellus" "NO-HO1-1_Tellus (14)" "NO-HO1" 14 no 
AddRoomMailbox "no-ho1-capella" "NO-HO1-Capella Video (6)" "NO-HO1" 6 no Video
AddRoomMailbox "no-ho1-helios" "NO-HO1-Helios Video (40)" "NO-HO1" 40 no Video
AddRoomMailbox "no-ho1-mars" "NO-HO1-Mars Video (7)" "NO-HO1" 7 no Video
AddRoomMailbox "no-ho1-neptun" "NO-HO1-Neptun Video (10)" "NO-HO1" 10 no Video
AddRoomMailbox "no-ho1-nova" "NO-HO1-Nova Video (8)" "NO-HO1" 8 no Video
AddRoomMailbox "no-ho1-pandor" "NO-HO1-Pandor Video (10)" "NO-HO1" 10 no Video
AddRoomMailbox "no-ho1-rigel" "NO-HO1-Rigel Video (3)" "NO-HO1" 3 no Video
AddRoomMailbox "no-ho1-uranus" "NO-HO1-Uranus Video (10)" "NO-HO1" 10 no Video
AddRoomMailbox "se-lp11-6-all-staff" "SE-LP11-6-ALL-STAFF Video (50)" "SE-LP11" 50 se Video
AddRoomMailbox "se-lp11-6-commitment" "SE-LP11-6-Commitment Video (6)" "SE-LP11" 6 se Video
AddRoomMailbox "se-lp11-6-diversity" "SE-LP11-6-Diversity Video (10)" "SE-LP11" 10 se Video
AddRoomMailbox "se-lp11-6-excel" "SE-LP11-6-Excel Video (1)" "SE-LP11" 1 se Video
AddRoomMailbox "se-lp11-6-explore" "SE-LP11-6-Explore Video (4)" "SE-LP11" 4 se Video
AddRoomMailbox "se-lp11-6-focus" "SE-LP11-6-Focus Video (3)" "SE-LP11" 3 se Video
AddRoomMailbox "se-lp11-6-growth" "SE-LP11-6-Growth Video (8)" "SE-LP11" 8 se Video
AddRoomMailbox "se-lp11-6-headquarters" "SE-LP11-6-Headquarters Video (26)" "SE-LP11" 26 se Video
AddRoomMailbox "se-lp11-6-idea" "SE-LP11-6-Idea Video (3)" "SE-LP11" 3 se Video
AddRoomMailbox "se-lp11-6-loyalty" "SE-LP11-6-Loyalty Video (6)" "SE-LP11" 6 se Video
AddRoomMailbox "se-lp11-6-respect" "SE-LP11-6-Respect Video (8)" "SE-LP11" 8 se Video
AddRoomMailbox "se-lp11-6-solution" "SE-LP11-6-Solution Video (12)" "SE-LP11" 12 se Video
AddRoomMailbox "se-lp11-6-together" "SE-LP11-6-Together Video (10)" "SE-LP11" 10 se Video
AddRoomMailbox "se-lp11-7-vision" "SE-LP11-7-Vision Video (12)" "SE-LP11" 12 se Video

return



