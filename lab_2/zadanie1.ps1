$sourceDir = "PrzykładyNaZajęcia\pliki"

$destinationDirTXT = "TXT"
$destinationDirLOG = "LOG"

if (!(Test-Path -Path $destinationDirTXT)) {
    New-Item -ItemType Directory -Path $destinationDirTXT
}
if (!(Test-Path -Path $destinationDirLOG)) {
    New-Item -ItemType Directory -Path $destinationDirLOG
}

Get-ChildItem -Path "$sourceDir\*" -Include *.txt -File | ForEach-Object {
    $newName = "kopia-" + $_.Name
    Copy-Item -Path $_.FullName -Destination (Join-Path $destinationDirTXT $newName)
}

Get-ChildItem -Path "$sourceDir\*" -Include *.log -File | ForEach-Object {
    $newName = "kopia-" + $_.Name
    Copy-Item -Path $_.FullName -Destination (Join-Path $destinationDirLOG $newName)
}