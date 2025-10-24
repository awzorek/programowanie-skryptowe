$Events = Get-WinEvent -FilterHashtable @{
    LogName   = 'Application'
    Level     = 2, 3
    StartTime = (Get-Date).AddDays(-7).Date
} | ForEach-Object {
    $FaultingApplicationName = "BRAK"
    if ($_.Id -eq 1000 -and $_.Properties.Count -gt 0) {
        $FaultingApplicationName = $_.Properties[0].Value
    }

    [PSCustomObject]@{
        TimeCreated             = $_.TimeCreated
        SourceName              = $_.ProviderName
        ProviderName            = $_.ProviderName
        EventID                 = $_.Id
        Level                   = $_.LevelDisplayName
        Message                 = $_.Message -replace "[\r\n]+"
        FaultingApplicationName = $FaultingApplicationName
    }
}

$events | Format-Table -AutoSize
$events | Export-Csv -Path "raport2.csv" -NoTypeInformation -Encoding UTF8

Write-Host "Liczba zdarzeń pogrupowana wg źródła zdarzenia (SourceName):"
$events | Group-Object -Property ProviderName | Sort-Object -Property Count -Descending | Format-Table -Property Count, Name -AutoSize

Write-Host "Liczba zdarzeń dla każdego poziomu (Error, Warning):"
$events | Group-Object -Property Level | Format-Table -Property Count, Name -AutoSize