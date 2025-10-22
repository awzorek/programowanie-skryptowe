$sourceDir = "PrzykładyNaZajęcia\pliki"
$csvFile = "plik.csv"
$logFile = "plik.log"

$txt = Get-ChildItem -Path $sourceDir -Include *.txt -File -Recurse
$log = Get-ChildItem -Path $sourceDir -Include *.log -File -Recurse

Write-Host "Liczba plików txt:" $txt.count ", liczba plików log:" $log.count

$txt | Select-Object Name, CreationTime, Length, Attributes | Export-Csv -Path $csvFile

$logLine = "$(Get-Date): znaleziono $($txt.Count) plików .txt i $($log.Count) plików .log"
Add-Content -Path $logFile -Value $logLine