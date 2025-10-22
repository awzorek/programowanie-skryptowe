# Parametry użytkownika
$homeDir = "$home\PS\pliki11"

# Utwórz nowy plik i zapisz do niego linie z aktualną datą
$nowyPlik = Join-Path -Path $homeDir -ChildPath "nowy_plik.txt"
$zawartosc = "Aktualna data: $(Get-Date)"
$zawartosc | Set-Content -Path $nowyPlik -Encoding UTF8

# Dopisz do pliku druga linię z data i aktualnych użytkownikiem
Add-Content -Path $nowyPlik -Value "$(Get-Date): Aktualny użytkownik: $env:USERNAME"
Add-Content -Path $nowyPlik -Value "$(Get-Date): Folder domowy: $env:USERPROFILE"
Add-Content -Path $nowyPlik -Value "$(Get-Date): Folder roboczy: $nowyPlik"

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

# Eksport do CSV
$logText | Export-Csv -Path "$sourceDir\logZad2.csv" -NoTypeInformation -Encoding UTF8

# Eksport do pliku tekstowego w czytelnym formacie tabelarycznym
$logText | Format-Table -AutoSize | Out-File -FilePath "$sourceDir\logZad2.txt" -Encoding UTF8