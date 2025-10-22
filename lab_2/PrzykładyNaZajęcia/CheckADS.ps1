# Skrypt do sprawdzania alternatywnych strumieni danych (ADS) w plikach
<# 
    .SYNOPSIS
    Skrypt do sprawdzania alternatywnych strumieni danych (ADS) w plikach
    .DESCRIPTION
    Ten skrypt sprawdza, czy wskazany plik zawiera alternatywne strumienie danych (ADS) i wyświetla ich nazwy oraz zawartość, jeśli to możliwe.
    .PARAMETER filePath
    Ścieżka do pliku, który ma być sprawdzany. Domyślnie ustawiona na "$home\PS\plik.txt".
    .EXAMPLE
    CheckADS.ps1 -filePath "C:\temp\dane.txt"
#>
param(
    # [Parameter(Mandatory=$true)]
    [string]$filePath = "$home\PS\plik.txt"
)

# -PathType Leaf - sprawdza czy istnieje i czy to plik
# -PathType Container - sprawdza czy istnieje i czy to katalog
# samo Test-Path sprawdza czy istnieje (plik lub katalog)
if (-Not (Test-Path $filePath)) {
    Write-Host "Plik '$filePath' nie istnieje." -ForegroundColor Red
    exit
}

# Pobranie listy strumieni danych
# Pobranie listy strumieni danych, z pominięciem domyślnego strumienia pliku
# Domyślny strumień to ":$DATA" lub "::DATA"
$streams = Get-Item -Path $filePath -Stream * | Where-Object { $_.Stream -notin @(':$DATA', '::DATA') }
# w konsoli można zobaczyć wszystkie strumienia poleceniem:
# Get-Item -Path $filePath -Stream *

if ($streams) {
    Write-Host "Znaleziono ADS w pliku: $filePath" -ForegroundColor Yellow
    foreach ($stream in $streams) {
        Write-Host " - Strumień: $($stream.Stream) (rozmiar: $($stream.Length) bajtów)"
        
        # Próba odczytu zawartości jako tekst
        try {
            $content = Get-Content -Path "$filePath`:$($stream.Stream)" -ErrorAction Stop
            Write-Host "   Zawartość:" -ForegroundColor Cyan
            $content | ForEach-Object { Write-Host "   $_" }
        }
        catch {
            Write-Host "   [Nie można odczytać zawartości jako tekst]" -ForegroundColor DarkGray
        }
    }
} else {
    Write-Host "Brak ADS w pliku: $filePath" -ForegroundColor Green
}
