
# -----------------------------------------------------------
# Username and password can be set in the file .env.ps1 which
# -----------------------------------------------------------
# $env:AADADMIN="admin-system@nets.eu"
# $env:AADADMINPASSWORD="*************"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
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

$Password = convertto-securestring $code -asplaintext -force
$credentials  = new-object System.Management.Automation.psCredential $username, $Password -ErrorAction:Stop

if (!$OutlookSession) {
    write-host "Importing session"
    $OutlookSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $credentials -Authentication Basic -AllowRedirection
    
    Import-PSSession $OutlookSession -AllowClobber 
}else{
    write-host "Reusing session"
}

