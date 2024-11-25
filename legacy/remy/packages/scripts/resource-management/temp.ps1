. "$PSScriptRoot\session-exchange.ps1"


$collection = Get-Content "$PSScriptRoot\..\..\data\adhoc.json" | ConvertFrom-Json



foreach ($item in $collection) {
    write-host "Remove-DistributionGroup"  $item
    Remove-UnifiedGroup  -Identity $item -Confirm:$false
     #Remove-DistributionGroup -Identity $item 
    # Remove-UnifiedGroup  -Identity $item 
    
}

