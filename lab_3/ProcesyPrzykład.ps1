# Wyświetlanie listy procesów wg ich czasu wykorzystania CPU
Get-Process | Sort-Object CPU -Desc | Select-Object -First 10 Name,Id,CPU,PM,StartTime
# Wyświetlanie procesów PowerShell oraz Code (VS Code)
Get-Process -Name PowerShell* | Format-Table Name,Id,CPU -AutoSize
Get-Process -Name Code* | Select-Object Name, Id, PriorityClass

# Wyświetlanie listy procesów wg ich czasu wykorzystania CPU
# CPU (s) — skumulowany czas CPU w sekundach (tak jak zwraca Get-Process).
# PM (MB) — pamięć prywatna w megabajtach.
# WorkingSet –  aktualnie załadowana pamięć RAM przez proces (pamieć prywatna + współdzielona) (bajty).

Get-Process |
  Sort-Object CPU -Descending |
  Select-Object -First 10 Name, Id, StartTime,
    # @{Name=''; Expression={}} - składnia tworzenia obliczanych kolumn
    # $_.CPU/.WorkingSet/.PM - odniesienie do właściwości CPU aktualnego obiektu w pipeline
    # [math]::Round() - zaokrąglanie liczb
    # [TimeSpan]::FromSeconds() - konwersja sekund na obiekt TimeSpan
    # ToString('d\.hh\:mm\:ss') - formatowanie czasu jako dni.godziny:minuty:sekundy
    @{Name='CPU (s)';        Expression = { [math]::Round($_.CPU,1) }},
    @{Name='CPU (d.h:m:s)';  Expression = { ([TimeSpan]::FromSeconds($_.CPU)).ToString('d\.hh\:mm\:ss') }},
    @{Name='Aktual RAM (MB)';Expression = { [math]::Round($_.WorkingSet / 1MB, 2) }},
    @{Name='PM (MB)';        Expression = { [math]::Round($_.PM / 1MB, 2) }} | Format-Table -AutoSize