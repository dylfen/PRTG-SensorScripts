<#
.SYNOPSIS
Count the days until a set date. 

.DESCRIPTION
Usefull to remind you of domain renewal, SSL certificate renewal or just count down to New Year.
The DateSensor.ps1 script count the days to a given day. You can set the days before warning and error state. The XML output can be used as PRTG custom sensor.

.PARAMETER Date (requirement)
Represents the date in date format YYYY-MM-DD

.PARAMETER $DaysForWarning (requirement)
Represents the number of days before getting a WARNING in PRTG. 0 = no warning

.PARAMETER $DaysForError (requirement)
Represents the number of days before getting a ERROR in PRTG. 0 = no error

.EXAMPLE
Count the days to New Year 19/20. Set warning limit to 30 days and error limit to 5.
DateSendor.ps1 -date 2019-12-31 -DaysForWarning 30 -DaysForError 5

Count the days to New Year 19/20. Set warning limit to 10 days.
DateSendor.ps1 -date 2019-12-31 -DaysForWarning 10 -DaysForError 0


.NOTES
Usage in PRTG:
1. Add the DateSendor.ps1 to "PRTG Network Monitor\Custom Sensors\EXEXML" folder.
2. Create a new "EXE/Script Advanced" sensor.
3. Choose the script DateSendor.ps1 under EXE/Script
4. Enter the following in parameters: -date YYYY-MM-DD -DaysForWarning 30 -DaysForError 5
5. Save
6. Enjoy

Author:  Dan Christensen   

.LINK
https://github.com/dylfen

#>
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
