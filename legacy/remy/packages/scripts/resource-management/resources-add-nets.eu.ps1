. "$PSScriptRoot\.env.ps1"
$domain = $env:AADDOMAIN
write-host $env:AADUSER
 
write-host $domain
 
#$OutlookSession = $null
# return
. "$PSScriptRoot\session-exchange.ps1"
#return
function AddLocation($displayName, $countryCode) {
   write-host "adding"  $displayName
   $alias = $displayName.ToLower()
   # Remove-DistributionGroup "rooms-$alias" -Confirm:$falseclear
   New-DistributionGroup -Alias "rooms-$alias"  -PrimarySmtpAddress "rooms-$alias@$domain" -Name $displayName  -RoomList 
}

 
function AddRoomMailbox ($key, $name, $location, $capacity, $country, $videodevice) {

   #  https://o365info.com/room-mailbox-powershell-commands/


   $alias = "room-$key" 
   # Remove-Mailbox "room-$key@$domain" -Confirm:$false   ## !! Doesn't work on rooms
   New-Mailbox  -Alias $alias -PrimarySmtpAddress "room-$key@$domain" -Name $name -DisplayName $name -Room -ResourceCapacity  $capacity 
   Add-DistributionGroupMember -Identity "rooms-$location" -Member $alias
   Set-Place  $alias   -Capacity $capacity -CountryOrRegion $country    -VideoDeviceName $videodevice   -Building $location
   Set-CalendarProcessing $alias -AllBookInPolicy: $False -BookInPolicy:"room-role-pa@$domain", "room-role-receptionist@$domain" -AddOrganizerToSubject $True
   Set-Mailbox $alias -MailTip "Room can only be reserved by PA's and receptionists"
   Add-MailBoxPermission $alias -User "room-role-receptionist@$domain" -AccessRights FullAccess
   Add-RecipientPermission $alias -Trustee "room-role-receptionist@$domain" -AccessRights SendAs -Confirm:$False 


}

# AddLocation "DK-EN1" "DK"
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

return
AddRoomMailbox "dk-en1-0.06" "DK-EN1-0.06 Video (8)" "DK-EN1" 8 dk Video
AddRoomMailbox "dk-en1-1.05" "DK-EN1-1.05 Video (6)" "DK-EN1" 6 dk Video
AddRoomMailbox "dk-en1-1.14" "DK-EN1-1.14 (4)" "DK-EN1" 4 dk 
AddRoomMailbox "dk-en1-1.51" "DK-EN1-1.51 (8)" "DK-EN1" 8 dk 
AddRoomMailbox "dk-en1-1.52" "DK-EN1-1.52 (20)" "DK-EN1" 20 dk 
AddRoomMailbox "dk-kb601-21a2" "DK-KB601-21A2 Video (16)" "DK-KB601" 16 dk Video
AddRoomMailbox "dk-kb601-21a3" "DK-KB601-21A3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-21a4" "DK-KB601-21A4 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-21a5" "DK-KB601-21A5 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-21a6" "DK-KB601-21A6 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-21c1" "DK-KB601-21C1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-21c2" "DK-KB601-21C2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-21c3" "DK-KB601-21C3 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-21c4" "DK-KB601-21C4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-21d1" "DK-KB601-21D1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-21d2" "DK-KB601-21D2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-21d3" "DK-KB601-21D3 Video (20)" "DK-KB601" 20 dk Video
AddRoomMailbox "dk-kb601-21d4" "DK-KB601-21D4 Video (20)" "DK-KB601" 20 dk Video
AddRoomMailbox "dk-kb601-21e1" "DK-KB601-21E1 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-22a1" "DK-KB601-22A1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-22a2" "DK-KB601-22A2 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-22a3" "DK-KB601-22A3 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-22a4" "DK-KB601-22A4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-22b1" "DK-KB601-22B1 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-22b2" "DK-KB601-22B2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-22c1" "DK-KB601-22C1 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-22c2" "DK-KB601-22C2 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-22c3" "DK-KB601-22C3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-22d1" "DK-KB601-22D1 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-22d2" "DK-KB601-22D2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-22d3" "DK-KB601-22D3 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-22d4" "DK-KB601-22D4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-22e1" "DK-KB601-22E1 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-22e2" "DK-KB601-22E2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-22a1" "DK-KB601-22A1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-23a2" "DK-KB601-23A2 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-23a3" "DK-KB601-23A3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-23a4" "DK-KB601-23A4 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-23b1" "DK-KB601-23B1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-23b2" "DK-KB601-23B2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-23c1" "DK-KB601-23C1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-23c2" "DK-KB601-23C2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-23c3" "DK-KB601-23C3 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-23d1" "DK-KB601-23D1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-23d2" "DK-KB601-23D2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-23e1" "DK-KB601-23E1 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-23e2" "DK-KB601-23E2 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-31m1" "DK-KB601-31M1 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-31m10" "DK-KB601-31M10 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-31m12" "DK-KB601-31M12 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-31m13" "DK-KB601-31M13 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-31m14" "DK-KB601-31M14 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-31m15" "DK-KB601-31M15 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-31m16" "DK-KB601-31M16 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-31m17" "DK-KB601-31M17 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-31m11" "DK-KB601-31M11 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-31m18" "DK-KB601-31M18 Video (24)" "DK-KB601" 24 dk Video
AddRoomMailbox "dk-kb601-31m2" "DK-KB601-31M2 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-31m3" "DK-KB601-31M3 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-31m4" "DK-KB601-31M4 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-31m5" "DK-KB601-31M5 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-31m6" "DK-KB601-31M6 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-31m7" "DK-KB601-31M7 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-31m8" "DK-KB601-31M8 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-31m9" "DK-KB601-31M9 Video (24)" "DK-KB601" 24 dk Video
AddRoomMailbox "dk-kb601-32a2" "DK-KB601-32A2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-32a3" "DK-KB601-32A3 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-32b1" "DK-KB601-32B1 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-32b2" "DK-KB601-32B2 (6)" "DK-KB601" 6 dk 
AddRoomMailbox "dk-kb601-32b3" "DK-KB601-32B3 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-32b4" "DK-KB601-32B4 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-32b5" "DK-KB601-32B5 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-32b6" "DK-KB601-32B6 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-32b7" "DK-KB601-32B7 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-32b8" "DK-KB601-32B8 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-32c1" "DK-KB601-32C1 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-32c2" "DK-KB601-32C2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-32c3" "DK-KB601-32C3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-32c4" "DK-KB601-32C4 Video (16)" "DK-KB601" 16 dk Video
AddRoomMailbox "dk-kb601-33a1" "DK-KB601-33A1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-33a2" "DK-KB601-33A2 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-33b1" "DK-KB601-33B1 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-33b2" "DK-KB601-33B2 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-33b3" "DK-KB601-33B3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-33b4" "DK-KB601-33B4 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-33c1" "DK-KB601-33C1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-33c2" "DK-KB601-33C2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-33d1" "DK-KB601-33D1 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-42a1" "DK-KB601-42A1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-42a2" "DK-KB601-42A2 (2)" "DK-KB601" 2 dk 
AddRoomMailbox "dk-kb601-42a3" "DK-KB601-42A3 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-42b1" "DK-KB601-42B1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-42b2" "DK-KB601-42B2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-42b3" "DK-KB601-42B3 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-42b4" "DK-KB601-42B4 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-42c1" "DK-KB601-42C1 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-kb601-42c2" "DK-KB601-42C2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-42c3" "DK-KB601-42C3 Video (12)" "DK-KB601" 12 dk Video
AddRoomMailbox "dk-kb601-42d1" "DK-KB601-42D1 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-42d2" "DK-KB601-42D2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-42d3" "DK-KB601-42D3 Video (6)" "DK-KB601" 6 dk Video
AddRoomMailbox "dk-kb601-43a1" "DK-KB601-43A1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-43a2" "DK-KB601-43A2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-43b1" "DK-KB601-43B1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-43b2" "DK-KB601-43B2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-43c1" "DK-KB601-43C1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-43c2" "DK-KB601-43C2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-43c3" "DK-KB601-43C3 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-43c4" "DK-KB601-43C4 (3)" "DK-KB601" 3 dk 
AddRoomMailbox "dk-kb601-43c5" "DK-KB601-43C5 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-43c6" "DK-KB601-43C6 Video (8)" "DK-KB601" 8 dk Video
AddRoomMailbox "dk-kb601-43d1" "DK-KB601-43D1 Video (2)" "DK-KB601" 2 dk Video
AddRoomMailbox "dk-kb601-43d2" "DK-KB601-43D2 Video (4)" "DK-KB601" 4 dk Video
AddRoomMailbox "dk-kb601-43d3" "DK-KB601-43D3 Video (10)" "DK-KB601" 10 dk Video
AddRoomMailbox "dk-lv24-1_jorden_3" "DK-LV241_JORDEN_3 Video (6)" "DK-LV24" 6 dk Video
AddRoomMailbox "dk-lv24-1_jorden_5" "DK-LV241_JORDEN_5 Video (5)" "DK-LV24" 5 dk Video
AddRoomMailbox "dk-lv24-1_jorden_8" "DK-LV241_JORDEN_8 Video (5)" "DK-LV24" 5 dk Video
AddRoomMailbox "dk-lv24-1_karlsvognen_8" "DK-LV241_KARLSVOGNEN_8 Video (8)" "DK-LV24" 8 dk Video
AddRoomMailbox "dk-lv24-1_orion_4" "DK-LV241_ORION_4 Video (4)" "DK-LV24" 4 dk Video
AddRoomMailbox "dk-lv24-m1" "DK-LV24M1 Video (6)" "DK-LV24" 6 dk Video
AddRoomMailbox "dk-lv24-m1" "DK-LV24M1 Video (6)" "DK-LV24" 6 dk Video
AddRoomMailbox "dk-lv24-m1" "DK-LV24M1 (8)" "DK-LV24" 8 dk 
AddRoomMailbox "dk-lv24-m1" "DK-LV24M1 Video (6)" "DK-LV24" 6 dk Video
AddRoomMailbox "dk-lv24-lille-bjoern" "DK-LV24Lille-Bjoern Video (4)" "DK-LV24" 4 dk Video
AddRoomMailbox "dk-lv24-store-bjoern" "DK-LV24Store-Bjoern Video (8)" "DK-LV24" 8 dk Video
AddRoomMailbox "dk-vh-1" "DK-VH1 (8)" "DK-VH" 8 dk 
AddRoomMailbox "dk-vh-2" "DK-VH2 (2)" "DK-VH" 2 dk 
AddRoomMailbox "dk-vh-m1" "DK-VHM1 (2)" "DK-VH" 2 dk 
AddRoomMailbox "dk-vh-b3" "DK-VHB3 (2)" "DK-VH" 2 dk 
AddRoomMailbox "dk-vh-5" "DK-VH5 (2)" "DK-VH" 2 dk 
AddRoomMailbox "fi-t21-ms-showroom" "FI-T21MS-Showroom (4)" "FI-T21" 4 fi 
AddRoomMailbox "fi-t21-4-c4224-vallisaari" "FI-T21-4C4224-Vallisaari Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-4-c4230-lonna" "FI-T21-4C4230-Lonna (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-4-c4243-villinki" "FI-T21-4C4243-Villinki (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-4-c4275-harmaja" "FI-T21-4C4275-Harmaja Video (5)" "FI-T21" 5 fi Video
AddRoomMailbox "fi-t21-4-d4426-haapasaari" "FI-T21-4D4426-Haapasaari (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-4-m1" "FI-T21-4M1 Video (13)" "FI-T21" 13 fi Video
AddRoomMailbox "fi-t21-4-m2" "FI-T21-4M2 (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-4-m3" "FI-T21-4M3 (12)" "FI-T21" 12 fi 
AddRoomMailbox "fi-t21-5-c5210-vartsala " "FI-T21-5C5210-Vartsala  Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-5-c5224-vasikkasaari" "FI-T21-5C5224-Vasikkasaari Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-5-c5230-öölanti" "FI-T21-5C5230-Öölanti (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-5-c5274-gotlanti" "FI-T21-5C5274-Gotlanti (16)" "FI-T21" 16 fi 
AddRoomMailbox "fi-t21-5-m4" "FI-T21-5M4 Video (9)" "FI-T21" 9 fi Video
AddRoomMailbox "fi-t21-5-m5" "FI-T21-5M5 Video (8)" "FI-T21" 8 fi Video
AddRoomMailbox "fi-t21-5-m6" "FI-T21-5M6 Video (12)" "FI-T21" 12 fi Video
AddRoomMailbox "fi-t21-6-b6474-suomenlinna " "FI-T21-6B6474-Suomenlinna  Video (22)" "FI-T21" 22 fi Video
AddRoomMailbox "fi-t21-6-c6212-vaindloo " "FI-T21-6C6212-Vaindloo  Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-6-c6226-seurasaari" "FI-T21-6C6226-Seurasaari (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-6-c6230-kustaanmiekk" "FI-T21-6C6230-Kustaanmiekk (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-6-c6243-sarkka" "FI-T21-6C6243-Särkkä Video (13)" "FI-T21" 13 fi Video
AddRoomMailbox "fi-t21-6-c6270-uunisaari" "FI-T21-6C6270-Uunisaari (13)" "FI-T21" 13 fi 
AddRoomMailbox "fi-t21-6-c6274-sappi" "FI-T21-6C6274-Säppi (1)" "FI-T21" 1 fi 
AddRoomMailbox "fi-t21-6-m7" "FI-T21-6M7 (9)" "FI-T21" 9 fi 
AddRoomMailbox "fi-t21-6-m8" "FI-T21-6M8 (9)" "FI-T21" 9 fi 
AddRoomMailbox "fi-t21-6-m9" "FI-T21-6M9 Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-6-canteen" "FI-T21-6Canteen Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-6-nettverket" "FI-T21-6Nettverket Video (3)" "FI-T21" 3 fi Video
AddRoomMailbox "fi-t21-6-pki" "FI-T21-6PKI Video (5)" "FI-T21" 5 fi Video
AddRoomMailbox "fi-t21-6-teknologi" "FI-T21-6Teknologi Video (5)" "FI-T21" 5 fi Video
AddRoomMailbox "fi-t21-6-arkivet" "FI-T21-6Arkivet (9)" "FI-T21" 9 fi 
AddRoomMailbox "fi-t21-7-c7243-kustavi" "FI-T21-7C7243-Kustavi (12)" "FI-T21" 12 fi 
AddRoomMailbox "fi-t21-7-c7274-otava" "FI-T21-7C7274-Otava (15)" "FI-T21" 15 fi 
AddRoomMailbox "fi-t21-7-avtalegiro" "FI-T21-7Avtalegiro Video (16)" "FI-T21" 16 fi Video
AddRoomMailbox "hr-rc50-blue" "HR-RC50Blue Video (7)" "HR-RC50" 7 hr Video
AddRoomMailbox "hr-rc50-bid" "HR-RC50BID Video (7)" "HR-RC50" 7 hr Video
AddRoomMailbox "hr-rc50-green" "HR-RC50Green Video (8)" "HR-RC50" 8 hr Video
AddRoomMailbox "hr-rc50-grey" "HR-RC50Grey Video (6)" "HR-RC50" 6 hr Video
AddRoomMailbox "hr-rc50-orange" "HR-RC50Orange Video (7)" "HR-RC50" 7 hr Video
AddRoomMailbox "hr-rc50-purple" "HR-RC50Purple Video (14)" "HR-RC50" 14 hr Video
AddRoomMailbox "hr-rc50-red" "HR-RC50Red Video (5)" "HR-RC50" 5 hr Video
AddRoomMailbox "hr-rc50-white" "HR-RC50White Video (20)" "HR-RC50" 20 hr Video
AddRoomMailbox "hr-rc50-yellow" "HR-RC50Yellow Video (12)" "HR-RC50" 12 hr Video
AddRoomMailbox "no-hm54-k0-m1" "NO-HM54-K0M1 (44)" "NO-HM54" 44 no 
AddRoomMailbox "no-hm54-k0-m2" "NO-HM54-K0M2 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k0-m3" "NO-HM54-K0M3 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k0-m4" "NO-HM54-K0M4 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k0-m5" "NO-HM54-K0M5 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k0-m6" "NO-HM54-K0M6 Video (8)" "NO-HM54" 8 no Video
AddRoomMailbox "no-hm54-k0-m7" "NO-HM54-K0M7 Video (10)" "NO-HM54" 10 no Video
AddRoomMailbox "no-hm54-k0-m8" "NO-HM54-K0M8 (24)" "NO-HM54" 24 no 
AddRoomMailbox "no-hm54-k0-m9" "NO-HM54-K0M9 (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k1-canteen" "NO-HM54-K1Canteen (150)" "NO-HM54" 150 no 
AddRoomMailbox "no-hm54-k1-nettverket" "NO-HM54-K1Nettverket Video (16)" "NO-HM54" 16 no Video
AddRoomMailbox "no-hm54-k1-pki" "NO-HM54-K1PKI Video (12)" "NO-HM54" 12 no Video
AddRoomMailbox "no-hm54-k1-teknologi" "NO-HM54-K1Teknologi Video (14)" "NO-HM54" 14 no Video
AddRoomMailbox "no-hm54-k2-arkivet" "NO-HM54-K2Arkivet Video (16)" "NO-HM54" 16 no Video
AddRoomMailbox "no-hm54-k3-avtalegiro" "NO-HM54-K3Avtalegiro Video (8)" "NO-HM54" 8 no Video
AddRoomMailbox "no-hm54-k4-bid" "NO-HM54-K4BID Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-k4-signatur" "NO-HM54-K4Signatur (8)" "NO-HM54" 8 no 
AddRoomMailbox "no-hm54-k4-tillitstjenester" "NO-HM54-K4Tillitstjenester (18)" "NO-HM54" 18 no 
AddRoomMailbox "no-hm54-d2-n-boersen" "NO-HM54-D2-NBoersen Video (8)" "NO-HM54" 8 no Video
AddRoomMailbox "no-hm54-d2-n-brynhild" "NO-HM54-D2-NBrynhild Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d2-n-katedralen" "NO-HM54-D2-NKatedralen (12)" "NO-HM54" 12 no 
AddRoomMailbox "no-hm54-d2-s-hubble" "NO-HM54-D2-SHubble Video (8)" "NO-HM54" 8 no Video
AddRoomMailbox "no-hm54-d2-s-jupiter" "NO-HM54-D2-SJupiter (14)" "NO-HM54" 14 no 
AddRoomMailbox "no-hm54-d2-s-mercur" "NO-HM54-D2-SMercur Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d2-s-pluto" "NO-HM54-D2-SPluto Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d2-s-saturn" "NO-HM54-D2-SSaturn Video (14)" "NO-HM54" 14 no Video
AddRoomMailbox "no-hm54-d3-n-odin" "NO-HM54-D3-NOdin Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d3-n-valhall" "NO-HM54-D3-NValhall (14)" "NO-HM54" 14 no 
AddRoomMailbox "no-hm54-d3-n-naasgard" "NO-HM54-D3-NNaasgard Video (14)" "NO-HM54" 14 no Video
AddRoomMailbox "no-hm54-d3-s-genesis" "NO-HM54-D3-SGenesis Video (1)" "NO-HM54" 1 no Video
AddRoomMailbox "no-hm54-d3-s-java" "NO-HM54-D3-SJava (14)" "NO-HM54" 14 no 
AddRoomMailbox "no-hm54-d3-s-oracle" "NO-HM54-D3-SOracle Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d3-s-pojo" "NO-HM54-D3-SPojo Video (4)" "NO-HM54" 4 no Video
AddRoomMailbox "no-hm54-d3-s-scrum room" "NO-HM54-D3-SScrum room Video (18)" "NO-HM54" 18 no Video
AddRoomMailbox "no-hm54-d3-s-stay" "NO-HM54-D3-SStay (14)" "NO-HM54" 14 no 
AddRoomMailbox "no-ho1-1_jupiter" "NO-HO11_Jupiter Video (10)" "NO-HO1" 10 no Video
AddRoomMailbox "no-ho1-1_merkur" "NO-HO11_Merkur (10)" "NO-HO1" 10 no 
AddRoomMailbox "no-ho1-1_saturn" "NO-HO11_Saturn (10)" "NO-HO1" 10 no 
AddRoomMailbox "no-ho1-1_tellus" "NO-HO11_Tellus (14)" "NO-HO1" 14 no 
AddRoomMailbox "no-ho1-capella" "NO-HO1Capella Video (6)" "NO-HO1" 6 no Video
AddRoomMailbox "no-ho1-helios" "NO-HO1Helios Video (40)" "NO-HO1" 40 no Video
AddRoomMailbox "no-ho1-mars" "NO-HO1Mars Video (7)" "NO-HO1" 7 no Video
AddRoomMailbox "no-ho1-neptun" "NO-HO1Neptun Video (10)" "NO-HO1" 10 no Video
AddRoomMailbox "no-ho1-nova" "NO-HO1Nova Video (8)" "NO-HO1" 8 no Video
AddRoomMailbox "no-ho1-pandor" "NO-HO1Pandor Video (10)" "NO-HO1" 10 no Video
AddRoomMailbox "no-ho1-rigel" "NO-HO1Rigel Video (3)" "NO-HO1" 3 no Video
AddRoomMailbox "no-ho1-uranus" "NO-HO1Uranus Video (10)" "NO-HO1" 10 no Video
AddRoomMailbox "se-lp11-6-all-staff" "SE-LP11-6ALL-STAFF Video (50)" "SE-LP11" 50 se Video
AddRoomMailbox "se-lp11-6-commitment" "SE-LP11-6Commitment Video (6)" "SE-LP11" 6 se Video
AddRoomMailbox "se-lp11-6-diversity" "SE-LP11-6Diversity Video (10)" "SE-LP11" 10 se Video
AddRoomMailbox "se-lp11-6-excel" "SE-LP11-6Excel Video (1)" "SE-LP11" 1 se Video
AddRoomMailbox "se-lp11-6-explore" "SE-LP11-6Explore Video (4)" "SE-LP11" 4 se Video
AddRoomMailbox "se-lp11-6-focus" "SE-LP11-6Focus Video (3)" "SE-LP11" 3 se Video
AddRoomMailbox "se-lp11-6-growth" "SE-LP11-6Growth Video (8)" "SE-LP11" 8 se Video
AddRoomMailbox "se-lp11-6-headquarters" "SE-LP11-6Headquarters Video (26)" "SE-LP11" 26 se Video
AddRoomMailbox "se-lp11-6-idea" "SE-LP11-6Idea Video (3)" "SE-LP11" 3 se Video
AddRoomMailbox "se-lp11-6-loyalty" "SE-LP11-6Loyalty Video (6)" "SE-LP11" 6 se Video
AddRoomMailbox "se-lp11-6-respect" "SE-LP11-6Respect Video (8)" "SE-LP11" 8 se Video
AddRoomMailbox "se-lp11-6-solution" "SE-LP11-6Solution Video (12)" "SE-LP11" 12 se Video
AddRoomMailbox "se-lp11-6-together" "SE-LP11-6Together Video (10)" "SE-LP11" 10 se Video
AddRoomMailbox "se-lp11-7-vision" "SE-LP11-7Vision Video (12)" "SE-LP11" 12 se Video





