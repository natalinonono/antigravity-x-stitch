$apiKey = $env:STITCH_API_KEY
if (-not $apiKey) {
    $apiKey = Read-Host "Masukkan STITCH_API_KEY Anda"
}
$screens = @(
    @{ id = "7529f3a590a74a39b27306d63251a529"; name = "screen1_portrait" },
    @{ id = "58d5ee75be6d4e968dd0203d927f1f9c"; name = "screen2_ecommerce_mockup" },
    @{ id = "4ac77b4675ea4663813f4dcb3b4a121d"; name = "screen3_dashboard_laptop" },
    @{ id = "15900f367fab4934a5e15a26d75a6c09"; name = "screen4_weather_analytics" },
    @{ id = "27218537bcb9421d81213589882b6c5c"; name = "screen5_kanban_board" },
    @{ id = "ee1a48ac30e04558bb64a95f0e6106bf"; name = "screen6_digital_portfolio" },
    @{ id = "a1e6f36e91b042cd89094f980bce750b"; name = "screen7_lentera_kehidupan" },
    @{ id = "039a3b5f11cd48ca846371b211bea146"; name = "screen8_siperu_purbowardayan" }
)

foreach ($item in $screens) {
    $url = "https://stitch.googleapis.com/v1/projects/6004328009543502431/screens/" + $item.id
    Write-Host "Fetching metadata for $($item.name) ($($item.id))..."
    $metaJson = curl.exe -s -H "X-Goog-Api-Key: $apiKey" $url
    $metaFile = $item.name + "_meta.json"
    [System.IO.File]::WriteAllText((Join-Path (Get-Location) $metaFile), $metaJson, [System.Text.Encoding]::UTF8)
    
    $obj = $metaJson | ConvertFrom-Json
    if ($obj.screenshot -and $obj.screenshot.downloadUrl) {
        $imgFile = $item.name + "_screenshot.png"
        Write-Host "Downloading screenshot to $imgFile..."
        curl.exe -L -s $obj.screenshot.downloadUrl -o $imgFile
    }
    if ($obj.htmlCode -and $obj.htmlCode.downloadUrl) {
        $codeFile = $item.name + "_code.html"
        Write-Host "Downloading html code to $codeFile..."
        curl.exe -L -s $obj.htmlCode.downloadUrl -o $codeFile
    }
}
Write-Host "Completed downloading all 8 assets!"