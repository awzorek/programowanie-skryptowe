# Raport zmian konfiguracji usług systemowych (ostatnie 14 dni)
$start = (Get-Date).AddDays(-14)
# 7040 - Service state change
# 7045 - A service was installed in the system
$zdarzenia = Get-WinEvent -FilterHashtable @{LogName='System'; Id=@(7045,7040); StartTime=$start} |
ForEach-Object {
    # Parsowanie XML zdarzenia
    [xml]$xml = $_.ToXml()
    $data = @{}
    # pobranie wartości pól po nazwie (z EventData)
    foreach ($d in $xml.Event.EventData.Data) {
        $data[$d.Name] = $d.'#text'
    }

    [PSCustomObject]@{
        TimeCreated     = $_.TimeCreated
        EventID         = $_.Id
        ServiceName     = $data["ServiceName"]
        ServiceFileName = $data["ImagePath"]
        StartType       = $data["StartType"]
        AccountName     = $data["AccountName"]
        MessageSummary  = ($_.Message -split "`n")[0]  # tylko pierwsza linia opisu
    }
}
# Wyświetlenie raportu
$zdarzenia | Format-Table -AutoSize


