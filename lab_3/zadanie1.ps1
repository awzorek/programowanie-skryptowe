$events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id = 4625
    StartTime = (Get-Date).AddDays(-14)
} | ForEach-Object {
    $xml = [xml]$_.ToXml()
    $properties = $xml.Event.EventData.Data

    [PSCustomObject]@{
        TimeCreated      = $_.TimeCreated
        TargetUserName   = ($properties | Where-Object { $_.Name -eq 'TargetUserName' }).'#text'
        TargetDomainName = ($properties | Where-Object { $_.Name -eq 'TargetDomainName' }).'#text'
        IpAddress        = ($properties | Where-Object { $_.Name -eq 'IpAddress' }).'#text'
        WorkstationName  = ($properties | Where-Object { $_.Name -eq 'WorkstationName' }).'#text'
        LogonType        = ($properties | Where-Object { $_.Name -eq 'LogonType' }).'#text'
        FailureReason    = ($properties | Where-Object { $_.Name -eq 'FailureReason' }).'#text'
        SubStatus        = ($properties | Where-Object { $_.Name -eq 'SubStatus' }).'#text'
    }
}

$events | Format-Table -AutoSize
$events | Export-Csv -Path "raport1.csv" -NoTypeInformation -Encoding UTF8

$allIp = $events | Where-Object { $_.IpAddress } | Group-Object IpAddress | Sort-Object Count -Descending

$topIp = $allIp[0].Name
$topIpCount = $allIp[0].Count
$lastAttempt = ($events | Where-Object { $_.IpAddress -eq $topIp } | Sort-Object TimeCreated -Descending)[0].TimeCreated

Write-Host "Najwięcej nieudanych prób logowania z IP: $topIp"
Write-Host "Liczba prób: $topIpCount"
Write-Host "Ostatnia próba: $lastAttempt"

Write-Host "`nLiczba nieudanych logowań według adresów IP:"
foreach ($group in $allIp) {
    Write-Host "$($group.Name): $($group.Count)"
}