# Skrypt PowerShell do modyfikacji właściwości pliku i alternatywnych strumieni danych (ADS)
# Ustawienie ścieżki do pliku
$homeDir = $env:USERPROFILE
$workDir = "$homeDir\PS"
$plik = "$workDir\dokument.txt"
$pictureFile = "$workDir\obraz.jpg"

# Zapisywanie informacji do pliku
# Użycie Set-Content do utworzenia pliku z zawartością
"Poufna informacja" | Set-Content $plik
# lub użyć Out-File, aby utworzyć plik z zawartością
# "Poufna informacja" | Out-File $plik -Encoding UTF8
#"Poufna informacja" | Out-File $plik

# Wyświetlenie podstawowych właściwości pliku
Write-Host "`n(1)--- Właściwości pliku po utworzeniu ---"
# Tworzenie wiadomości o właściwościach pliku
# Użycie Format-Table do sformatowania wyjścia  | Out-String umożliwia przechwycenie wyników w zmiennej
# i późniejsze ich wyświetlenie
# -Force umożlwia pobranie właściwości nawet jeśli plik jest ukryty
$info1 = Get-Item $plik -Force | Format-Table Name, CreationTime, LastWriteTime, Attributes -AutoSize | Out-String
Write-Host $info1 

# Ustawienie dat utworzenia i modyfikacji
(Get-Item $plik).CreationTime = "2022-01-01 10:00:00"
Set-ItemProperty -Path $plik -Name LastWriteTime -Value "2022-01-01 10:05:00"

# Sprawdzenie i wyświetlenie zawartości alternatywnych strumieni danych

# Dodanie alternatywnego strumienia danych (ADS) wskazującego na strefę bezpieczeństwa
# Wartość ZoneId=3 oznacza, że plik pochodzi z Internetu
# Sprawdzenie czy strumień Zone.Identifier istnieje
if (Get-Item -Path $plik -Stream 'Zone.Identifier' -ErrorAction SilentlyContinue) {
    # Strumień istnieje
    Write-Host "(2)Strumień Zone.Identifier istnieje." -ForegroundColor Green
    # Wyświetlenie zawartości strumienia Zone.Identifier
    Get-Content "$plik`:`Zone.Identifier" | ForEach-Object { Write-Host $_ }
    
} else {
    Write-Host "(3)Strumień Zone.Identifier nie istnieje." -ForegroundColor Red
    Write-Host "`n--- Dodanie strumienia Zone.Identifier z ZoneId=3---"
    Add-Content "$plik`:`Zone.Identifier" "[ZoneTransfer]`nZoneId=3"
    
    # Użycie  Write-Host powoduje, że każda linia będzie wyświetlana osobno w konsoli a nie dodana do potoku
    Get-Content "$plik`:`Zone.Identifier" | ForEach-Object { Write-Host $_ }
}

# Dodanie alternatywnego strumienia danych (ADS) z informacją o autorze
# Sprawdzenie i wyświetlenie zawartości strumienia Autor 
# Można używać dowolnej nazwy strumienia, np. "Autor"
if (Get-Item -Path $plik -Stream 'Autor' -ErrorAction SilentlyContinue) {
    Write-Host "(4)Strumień Autor istnieje więc usuwam." -ForegroundColor Green
    # Usunięcie istniejącego strumienia
    Remove-Item -Path $plik -Stream 'Autor'
} else {
    Write-Host "(5)Strumień Autor nie istnieje." -ForegroundColor Red
    Write-Host "Dodanie strumienia Autor."
    Set-Content "$plik`:`Autor" "Jan Kowalski, dział IT"
    # Można użyć Add-Content, aby dodać więcej informacji do tego samego strumienia
    Add-Content "$plik`:`Autor" "Jan Nowak, dział DEV"
}
Write-Host "`n(6)--- Zawartość strumienia Autor o ile istnieje---"
#"$plik`:`Autor"
if (Get-Item -Path $plik -Stream 'Autor' -ErrorAction SilentlyContinue) {
    Get-Content "$plik`:`Autor" | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "(7)Strumień Autor nie istnieje." -ForegroundColor Red
}

# Dodanie alternatywnego strumienia danych (ADS) w postaci pliku jpg
# Sprawdzenie i wyświetlenie zawartości strumienia Obraz
if (Get-Item -Path $plik -Stream 'Obraz' -ErrorAction SilentlyContinue) {
    Write-Host "(8)Strumień Obraz istnieje." -ForegroundColor Green
    # Get-Content "$plik`:`Obraz" | ForEach-Object { Write-Host $_ }; to spowoduje wyświetlenie zawartości binarnej
    # Odczyt ADS i zapis jako normalny plik JPEG
    Get-Content "$plik`:`Obraz" -Encoding Byte -ReadCount 0 |
    Set-Content "$workDir\odzyskany.jpg" -Encoding Byte

} else {
    Write-Host "(9)Strumień Obraz nie istnieje." -ForegroundColor Red
    Write-Host "Dodanie strumienia Obraz."
    # Użycie Set-Content do utworzenia strumienia z zawartością pliku jpg
    # Set-Content "$plik`:`Obraz" -Value ([System.IO.File]::ReadAllBytes("C:\path\to\image.jpg"))
    Get-Content $pictureFile -Encoding Byte -ReadCount 0 |
    Set-Content "$plik`:`Obraz" -Encoding Byte
}   

# Ukrycie folderu i ustawienie atrybutu tylko do odczytu 
# nie powoduje, że pliki w folderze są ukryte i nie można ich modyfikować
Set-ItemProperty -Path $workDir -Name Attributes -Value "Hidden,ReadOnly"
# Powyższą linię można zastąpić krótszą wersją
# (Get-Item $workDir).Attributes = "Hidden,ReadOnly"

# Ukrycie pliku i ustawienie atrybutu tylko do odczytu
# Plik będzie widoczny w eksploratorze, ale nie będzie można go modyfikować
# ale będzie można go skopiować, przenieść lub usunąć
Set-ItemProperty -Path $plik -Name Attributes -Value "Hidden,ReadOnly"

Write-Host "`n(10)--- Właściwości pliku po modyfikacji ---"
# Wyświetlenie nazwy, dat utworzenia i modyfikacji oraz atrybutów
# Użycie -Force pozwala na pobranie właściwości nawet jeśli plik jest ukryty
$info1 = Get-Item $plik -Force | Format-Table Name, CreationTime, LastWriteTime, Attributes -AutoSize | Out-String
Write-Host $info1

# Ponowne ustawienie atrybutów pliku na Archive, aby plik był widoczny w eksploratorze
Set-ItemProperty -Path $plik -Name Attributes -Value "Archive" -Force