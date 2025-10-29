$StartHoursAgo = [int]$args[0]

$StartTime = (Get-Date).AddHours(-$StartHoursAgo)
$Timestamp = Get-Date -Format "yyyy-MM-dd-HH-mm"
$OutputFile = "windows_events_$($Timestamp).csv"

$SecurityFilter = @{
    LogName = 'Security'
    StartTime = $StartTime
    ID = 4720, 4722, 4723
}
$SystemFilter = @{
    LogName = 'System'
    StartTime = $StartTime
    ID = 7045, 6005, 6006
}

$Events = @()
$Events += Get-WinEvent -FilterHashtable $SecurityFilter -ErrorAction Stop
$Events += Get-WinEvent -FilterHashtable $SystemFilter -ErrorAction Stop

$ReportData = $Events | ForEach-Object {
    $EventXml = [xml]$_.ToXml()
    
    $Data = @{}
    
    if ($EventXml -and $EventXml.Event.EventData) {
        $EventXml.Event.EventData.Data | ForEach-Object {
            if ($_.Name) { 
                $Data[$_.Name] = $_.'#text' 
            }
        }
    }
    
    [PSCustomObject]@{
        TimeCreated    = $_.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
        EventID        = $_.Id
        ProviderName   = $_.ProviderName
        MachineName    = $_.MachineName
        LogName        = $_.LogName
        Message        = if ($_.Message) { ($_.Message.Trim() -replace '\s{2,}', ' ').Trim() } else { "" }
        TargetUserName = if ($Data.ContainsKey('TargetUserName')) { $Data.TargetUserName } else { "" }
        SubjectUserName= if ($Data.ContainsKey('SubjectUserName')) { $Data.SubjectUserName } else { "" }
        ServiceName    = if ($Data.ContainsKey('ServiceName')) { $Data.ServiceName } else { "" }
        ServiceFileName= if ($Data.ContainsKey('ServiceFileName')) { $Data.ServiceFileName } else { "" }
    }
}

$ReportData | Format-Table -AutoSize

$ReportData | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8