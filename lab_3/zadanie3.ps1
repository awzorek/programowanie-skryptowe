function Find-ProcessByName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$processPattern
    )

    $processes = Get-Process -Name $processPattern | Select-Object Name, Id, @{Name = "RAM_MB"; Expression = { ($_.WorkingSet64 / 1MB) } }

    $processes | Format-Table -AutoSize -Property Name, Id, @{Name = "RAM (MB)"; Expression = { $_.RAM_MB }; FormatString = "N2" }

    $stats = $processes | Measure-Object -Property RAM_MB -Sum -Average

    Write-Host "Łączna liczba procesów: $($stats.Count)"
    Write-Host ("Łączne zużycie RAM: {0:N2} MB" -f $stats.Sum)
    Write-Host ("Średnie zużycie RAM: {0:N2} MB" -f $stats.Average)
}

Find-ProcessByName @args