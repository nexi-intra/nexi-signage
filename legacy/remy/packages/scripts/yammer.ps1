$baererToken = "5356126209-22T9ffkvJ4WMeDSZC28zQ"

$headers = @{ Authorization=("Bearer " + $baererToken) }


$webRequest = Invoke-WebRequest -Uri "https://www.yammer.com/api/v1/messages.json" -Headers $headers

if ($webRequest.StatusCode -eq 200) {
    $results = $webRequest.Content | ConvertFrom-Json

    $results.messages | ForEach-Object {
        $message = $_ 
        Write-Host $message.id
        Write-Host $message.body.plain
    }
}
