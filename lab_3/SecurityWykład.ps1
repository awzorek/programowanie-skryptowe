# Skrypt: eksport_nieudanych_logowan.ps1
# Opis: Eksportuje nieudane logowania (EventID 4625) do pliku CSV
# Filtrowanie zdarzeń z dziennika Security
$logowania = Get-WinEvent -FilterHashtable @{
    LogName = 'Security';
    Id = 4625;
    StartTime = (Get-Date).AddDays(-7)  # ostatnie 7 dni
} | ForEach-Object {
    # Parsowanie danych z wiadomości
    $data = [xml]$_.ToXml()
    $properties = $data.Event.EventData.Data
    # Wyciągnięcie kluczowych informacji
    # PSCustomObject - to specjalny obiekt PowerShell do przechowywania danych w formie klucz-wartość
    [PSCustomObject]@{
        TimeCreated  = $_.TimeCreated
        UserName     = ($properties | Where-Object {$_.Name -eq 'TargetUserName'}).'#text'
        IPAddress    = ($properties | Where-Object {$_.Name -eq 'IpAddress'}).'#text'
        Status       = ($properties | Where-Object {$_.Name -eq 'Status'}).'#text'
        FailureReason = ($properties | Where-Object {$_.Name -eq 'FailureReason'}).'#text'
        Message       = $_.Message
    }
}
# wyświetlenie wyników w tabeli
$logowania | Format-Table -AutoSize
# Eksport do pliku CSV
#$logowania | Export-Csv -Path "C:\temp\nieudane_logowania.csv" -NoTypeInformation
#Write-Host "Eksport zakończony. Plik: C:\temp\nieudane_logowania.csv"
