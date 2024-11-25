# Elevate 
# Install-Module SharePointPnPPowerShellOnline
#Add-PSSnapin  SharePointPnPPowerShellOnline

Connect-PnPOnline -Url "https://christianiabpos.sharepoint.com/sites/ToolsRemyNetsGroup"

Get-PnPProvisioningTemplate -out "$PSScriptRoot\room-management.xml"