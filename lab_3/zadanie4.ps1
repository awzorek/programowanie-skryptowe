$StartHoursAgo = [int]$args[0]

$StartTime = (Get-Date).AddHours(-$StartHoursAgo)
$Timestamp = Get-Date -Format "yyyy-MM-dd-HH-mm"
$OutputFile = "windows_logons_$($Timestamp).csv"

$LogonFilter = @{
    LogName = 'Security'
    StartTime = $StartTime
    ID = 4624, 4625
}

$Events = Get-WinEvent -FilterHashTable $LogonFilter

$LogonData = $Events | ForEach-Object {
    $EventXml = [xml]$_.ToXml()
    
    $Data = @{}
    $EventXml.Event.EventData.Data | ForEach-Object {
        if ($_.Name) {
            $Data[$_.Name] = $_.'#text'
        }
    }

    $LogonResult = if ($_.Id -eq 4624) {"Sukces"} else {"Niepowodzenie"}
    $LogonTypeDescription = switch ($Data['LogonType']) {
        2 {"Interakcyjne"}
        3 {"Sieciowe"}
        10 {"Zdalny pulpit"}
        default {"Inny ($($Data['LogonType']))"}
    }

    [PSCustomObject]@{
        TimeCreated      = $_.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
        EventID          = $_.Id
        LogonType        = $LogonTypeDescription
        LogonResult      = $LogonResult
        TargetUserName   = $Data['TargetUserName']
        IPAddress        = $Data['IpAddress']
        MachineName      = $_.MachineName
        Message          = $_.Message.Trim().Split("`n")[0]
    }
}

if ($LogonData) {    
    $LogonData | Select-Object TimeCreated, EventID, LogonResult, LogonType, TargetUserName, IPAddress, MachineName | Format-Table -AutoSize
    
    $LogonData | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
}