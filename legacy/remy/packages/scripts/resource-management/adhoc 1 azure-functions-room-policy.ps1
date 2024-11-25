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

Set-CalendarProcessing "room-dk-kb601-22a3@nets.eu" -AllBookInPolicy:$False -BookInPolicy:"room-policy-dk-kb601-project-room@nets.eu", "room-role-receptionist@$domain"
