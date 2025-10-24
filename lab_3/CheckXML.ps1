$e = Get-WinEvent -LogName System -MaxEvents 1
$xml = [xml]$e.ToXml()
$xml.Event.System | Format-List *    # pola z sekcji <System> (Provider, EventID, Level, Task, Keywords, TimeCreated, EventRecordID, Channel, Computer, Security)
$xml.Event.EventData | Format-List * # dane z sekcji <EventData>