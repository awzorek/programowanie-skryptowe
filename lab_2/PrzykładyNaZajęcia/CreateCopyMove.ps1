# pobierz obiekt pliku
$plik = Get-Item "C:\temp\dane.txt"
$folder = Get-Item "C:\temp"

# wyświetl właściwości pliku
$plik | Format-List Name, Length, LastWriteTime, CreationTime
# lub
$plik.Name
$plik.Length

# utwórz nowy katalog korzystając z cmdlet'a New-Item   
# -Force powoduje nadpisanie katalogu, jeśli już istnieje
New-Item -Path "C:\temp\kopia" -ItemType Directory -Force

# -Force powoduje nadpisanie pliku, jeśli już istnieje
$destinationPath = "C:\temp\dane_kopia.txt"
Copy-Item -Path $plik.FullName -Destination $destinationPath -Force

# przenieś plik do innego katalogu
$sourcePath = $destinationPath
$destinationPath = "C:\temp\kopia\dane_druga_kopia.txt"
Move-Item -Path $sourcePath -Destination $destinationPath -Force

# Utwórz obiekt z informacjami o pliku
# Ułatwia export do CSV oraz ładne formatowanie Format-Table
$homeDir = $env:USERPROFILE
$sourceDir = "$homeDir\PS"

$listaPlików = Get-ChildItem -Path $sourceDir -Recurse
Write-Host "Znaleziono  $($listaPlików.Count) plików."
# Utwórz tablicę do logowania
$logText = @()

foreach ($file in $listaPlików) {
    # Write-Host "Plik: $file"
    if ($file.Name -like "*.txt") { 
        $entry = [PSCustomObject]@{
        Nazwa       = $file.Name
        RozmiarKB   = [math]::Round($file.Length / 1KB, 2)
        # Popraw formatowanie daty aby nie wyświetlało sekund
        Utworzono   = $file.CreationTime.ToString("yyyy-MM-dd HH:mm")
        Modyfikacja = $file.LastWriteTime
        Atrybuty    = $file.Attributes
        }
        # dodaj obiekt do logu
        $logText += $entry
        }
}
Write-Host "Objekt:"
$logText | Format-Table -AutoSize

