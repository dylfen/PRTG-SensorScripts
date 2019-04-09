Param([datetime]$Date,
      [int]$DaysForWarning,
      [int]$DaysForError
)

if($DaysForWarning -lt $DaysForError) { Write-Host "DaysForWarning can't be less then DaysForError" exit 1 }

$DateDiff = New-TimeSpan -Start (Get-Date) -End $Date

$Days = $DateDiff.Days
if($datediff.Days -eq 0 -and $DateDiff.Hours -gt 0) { $Days =+ 1 } 
$DaysPassed = ($Days * -1)
$xmlOutput = "<?xml version=""1.0"" encoding=""UTF-8"" ?><prtg>
    <result>
    <channel>Day(s) until date</channel>
    <value>$Days</value>
    <customunit>day(s)</customunit>
    <LimitMode>1</LimitMode>
    <LimitMinWarning>$DaysForWarning</LimitMinWarning>
    <LimitMinError>$DaysForError</LimitMinError></result>"

if($Days -gt $DaysForWarning){
    $xmlOutput = $xmlOutput + "<text>$days day(s) until date</text>"
}
if($Days -le $DaysForWarning -and $Days -gt $DaysForError -and $Days -gt 0){
    $xmlOutput = $xmlOutput + "<text>Warning: $days day(s) until date</text>"
}
if($Days -le $DaysForError -and $Days -gt 0){
    $xmlOutput = $xmlOutput + "<text>Error: $days day(s) until date</text>"
}
if($Days -eq 0){
    $xmlOutput = $xmlOutput + "<text>Date is today!!</text>"
}
if($Days -lt 0){
    $xmlOutput = $xmlOutput + "<text>Date was $days day(s) ago!!</text>"
}
$xmlOutput = $xmlOutput + "</prtg>"
$xmlOutput
$xmlOutput = ""