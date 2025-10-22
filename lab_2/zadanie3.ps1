$folderPath = $args[0]

if (!(Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
}

for ($i = 1; $i -le 5; $i++) {
    $fileName = "plik$i.txt"
    $filePath = Join-Path $folderPath $fileName
    "plik $i" | Out-File -FilePath $filePath -Encoding UTF8
}

$csvPath = Join-Path $folderPath "raport.csv"

$fileInfo = Get-ChildItem -Path $folderPath -Filter *.txt | Select-Object Name, FullName, @{Name="Size";Expression={[math]::Round($_.Length / 1KB, 2)}}, CreationTime, LastWriteTime | Format-Table -AutoSize | Export-Csv -Path $csvPath

$newDate = Get-Date "2000-01-01 12:00"
Get-ChildItem -Path $folderPath -Filter *.txt | ForEach-Object {
    $_.CreationTime = $newDate
}

Get-ChildItem -Path $folderPath -Filter *.txt | Select-Object -First 2 | ForEach-Object {
    $_.Attributes = "Hidden"
}

$txtPath = Join-Path $folderPath "raport_atrybuty.txt"
Get-ChildItem -Path $folderPath -Filter *.txt -Force | Select-Object Name, Attributes, CreationTime, LastWriteTime | Out-File -FilePath $txtPath -Encoding UTF8