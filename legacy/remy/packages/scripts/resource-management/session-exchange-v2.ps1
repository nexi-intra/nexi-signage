
# -----------------------------------------------------------
# Username and password can be set in the file .env.ps1 which
# -----------------------------------------------------------
# $env:AADADMIN="admin-system@nets.eu"
# $env:AADADMINPASSWORD="*************"
# https://docs.microsoft.com/en-us/powershell/exchange/exchange-online-powershell-v2?view=exchange-ps
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Install-Module -Name ExchangeOnlineManagement
#return 

$code = $env:AADPASSWORD 
$username = $env:AADUSER

if (!$code )  { 
    write-host "Missing environment variable AADPASSWORD" 
    exit 
}

if ( !$username ) {
    write-host "Missing environment variable AADUSER"
    exit 
}
Import-Module ExchangeOnlineManagement
$Password = convertto-securestring $code -asplaintext -force
$credentials  = new-object System.Management.Automation.psCredential $username, $Password -ErrorAction:Stop

if (!$ExchangeSession) {
    write-host "Importing session"
    $ExchangeSession = Connect-ExchangeOnline #-Credential $credentials -ShowProgress $true
}else{
    write-host "Reusing session"
}

