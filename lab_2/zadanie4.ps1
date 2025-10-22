$filePath = $args[0]

Get-Item -Path $filePath -Stream * | Where-Object { $_.Stream -ne ":$($_.Name)" } | Select-Object Stream, Length, @{Name="Content"; Expression = {(Get-Content -Path $_.PSPath -Stream $_.Stream) -Join ", " }} | Format-Table -AutoSize

$newADS = @{"Recenzent" = "Jan Kowalski`nAnna Nowak"; "Śledztwo" = "Akta 32/2025"; "Departament" = "DEV"}

foreach ($ADS in $newADS.Keys) {
    $newADS[$ADS] | Set-Content -Path $filePath -Stream $ADS
}

Write-Host "Dodane ADS:"
foreach ($ADS in $newADS.Keys) {
    Write-Host "$ADS : " -NoNewline
    (Get-Content -Path $filePath -Stream $ADS) -Join ", "
}