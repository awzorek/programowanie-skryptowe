# Skrypt PowerShell do pobierania i wyświetlania informacji ogólnych o zdarzeniach z dzienników zdarzeń Windows

# Ustawienia filtrowania zdarzeń
$filterParams = @{
    LogName = "Security"
    MaxEvents = 1
}

# Pobierz zdarzenia
$events = Get-WinEvent @filterParams

# Wyświetl informacje ogólne dla każdego zdarzenia
foreach ($evt in $events) {
    Write-Host "INFORMACJE OGÓLNE - Zdarzenie $($evt.RecordId)"
    # Informacje z zakładki "Ogólne" Event Viewera
    Write-Host "Źródło (Provider Name): " $evt.ProviderName -ForegroundColor Green
    Write-Host "ID zdarzenia: " $evt.Id -ForegroundColor Yellow
    Write-Host "Poziom (Level): " $evt.LevelDisplayName -ForegroundColor Cyan
    Write-Host "Użytkownik (User): " $(if($evt.UserId) {$evt.UserId} else {"N/A"}) -ForegroundColor Magenta
    Write-Host "Komputer (Computer): " $evt.MachineName -ForegroundColor Blue
    Write-Host "Czas utworzenia: " $evt.TimeCreated -ForegroundColor White
    Write-Host "Kategoria zadania: " $(if($evt.TaskDisplayName) {$evt.TaskDisplayName} else {"N/A"}) -ForegroundColor Gray
    Write-Host "Słowa kluczowe: " ($evt.KeywordsDisplayNames -join ', ') -ForegroundColor DarkYellow
    Write-Host "Dziennik (Log Name): " $evt.LogName -ForegroundColor Red
    Write-Host "Kanał (Channel): " $evt.LogName -ForegroundColor DarkRed
    Write-Host "Opcode: " $(if($evt.OpcodeDisplayName) {$evt.OpcodeDisplayName} else {"N/A"}) -ForegroundColor DarkGreen
    Write-Host "Record ID: " $evt.RecordId -ForegroundColor DarkCyan
    Write-Host "Process ID: " $(if($evt.ProcessId) {$evt.ProcessId} else {"N/A"}) -ForegroundColor DarkMagenta
    Write-Host "Thread ID: " $(if($evt.ThreadId) {$evt.ThreadId} else {"N/A"}) -ForegroundColor DarkBlue
    # Opis zdarzenia (Message)
    Write-Host "`nOpis zdarzenia:"
    Write-Host $evt.Message -ForegroundColor Yellow 
    Write-Host "Koniec informacji o zdarzeniu.`n"
}