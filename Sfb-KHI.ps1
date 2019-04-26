<#
.SYNOPSIS
Retrieves 38 HKIs (Key Health Indicators) fron your SFB FE server

.DESCRIPTION
The Sfb-KHI.ps1 script gets the current KHI values from your S4B FE server via counters. The XML output can be used as PRTG custom sensor.

.PARAMETER Server 
Represents the server you will connect to. HOSTNAME or IP

.PARAMETER Username (requirement)
Represents the username for authentication to the server

.PARAMETER Password (requirement)
Represents the password for authentication to the server

.EXAMPLE
Retrieves KHI counters from SFB FE server.
Sfb-KHI.ps1 -server "MySfbServer" -noprofile -executionpolicy bypass -UserName MyDomain\sfbadmin -Password "12345"

.NOTES
Usage in PRTG:
1. Add the Sfb-KHI.ps1 to "PRTG Network Monitor\Custom Sensors\EXEXML" folder.
2. Create a new "EXE/Script Advanced" sensor.
3. Choose the script Sfb-KHI.ps1 under EXE/Script
4. Enter the following in parameters: -server "YOURSERVER" -noprofile -executionpolicy bypass -UserName %windowsdomain\%windowsuser -Password "%windowspassword"
5. Save
6. Enjoy

Author:  Dan Christensen   

.LINK
https://github.com/dylfen

#>

param (
    [string]$server= "",
    [string]$username= "",
    [string]$password= ""
)

$SecPasswd = ConvertTo-SecureString $Password -AsPlainText -Force 
$Credentials= New-Object System.Management.Automation.PSCredential ($Username, $secpasswd) 


$value0 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\MSSQL`$RTCLOCAL:Buffer Manager\Page life expectancy" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value1 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\MSSQL`$LYNCLOCAL:Buffer Manager\Page life expectancy" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value2 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:Usrv - DBStore\Usrv - Queue Latency (msec)" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value3 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:Usrv - DBStore\Usrv - Sproc Latency (msec)" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value4 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:Usrv - DBStore\Usrv - Throttled requests/sec" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value5 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:Usrv - REGDBStore\Usrv - Queue Latency (msec)" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value6 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:Usrv - REGDBStore\Usrv - Sproc Latency (msec)" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value7 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:Usrv - REGDBStore\Usrv - Throttled requests/sec" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value8 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:Usrv - SharedDBStore\Usrv - Queue Latency (msec)" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value9 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:Usrv - SharedDBStore\Usrv - Sproc Latency (msec)" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value10 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:Usrv - SharedDBStore\Usrv - Throttled requests/sec" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value11 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Load Management\SIP - Average Holding Time For Incoming Messages" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value12 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Load Management\SIP - Incoming Messages Timed out" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value13 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Peers(_total)\SIP - Average outgoing Queue Delay" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value14 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Peers(_total)\SIP - Flow-controlled Connections" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value15 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Protocol\SIP - Average Incoming Message Processing Time" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value16 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:XMPPFederation - SIP Instant Messaging\XMPPFederation - Failure IMDNs sent/sec" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value17 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:RoutingApps - Emergency Call Routing\RoutingApps - Number of incoming failure responses" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value18 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:CAA - Operations\CAA - Incomplete calls per sec" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value19 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Conference Mcu Allocator\USrv - Create Conference Latency (msec)" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value20 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\ASP.NET Apps v4.0.30319(__total__)\Requests Rejected" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value21 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:JoinLauncher - Join Launcher Service Failures\JOINLAUNCHER - Join Failures" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value22 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:WEB - Address Book File Download\WEB - Failed File Requests/Second" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value23 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:WEB - Address Book Web Query\WEB - Failed search requests/sec" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value24 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:WEB - Auth Provider related calls\WEB - Failed validate cert calls to the cert auth provider" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value25 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:WEB - Distribution List Expansion\WEB - Timed out Active Directory Requests/sec" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value26 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:ASMCU - MCU Health And Performance\ASMCU - MCU Health State" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value27 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:AVMCU - MCU Health And Performance\AVMCU - MCU Health State" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value28 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:DATAMCU - MCU Health And Performance\DATAMCU - MCU Health State" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value29 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:IMMCU - MCU Health And Performance\IMMCU - MCU Health State" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value30 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:IMMCU - IMMcu Conferences\IMMCU - Throttled Sip Connections" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value31 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Global Counters\- Total failed calls caused by unexpected interaction from the Proxy" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value32 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Global Per Gateway Counters(_total)\- Total failed calls caused by unexpected interaction from a gateway" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value33 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Health Indices\- Load Call Failure Index" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value34 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Media Relay\- Candidates Missing" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value35 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Media Relay\- Media Connectivity Check Failure" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value36 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Peers(_total)\SIP - Flow-controlled Connections" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
$value37 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Protocol\SIP - Average Incoming Message Processing Time" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials

$result='<?xml version="1.0" encoding="UTF-8" ?><prtg>'
$result+="  <result>"
$result+="    <channel>MSSQL`$RTCLOCAL:Buffer Manager – Page Life Expectancy</channel>"
$result+="    <value>"+$value0.CookedValue+"</value>"
$result+="    <CustomUnit>seconds</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMinError>200</LimitMinError>"
$result+="    <LimitMinWarning>300</LimitMinWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>MSSQL`$LYNCLOCAL:Buffer Manager – Page Life Expectancy</channel>"
$result+="    <value>"+$value1.CookedValue+"</value>"
$result+="    <CustomUnit>seconds</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMinError>200</LimitMinError>"
$result+="    <LimitMinWarning>300</LimitMinWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Usrv-DBStore Queue Latency (msec)</channel>"
$result+="    <value>"+$value2.CookedValue+"</value>"
$result+="    <CustomUnit>ms</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>150</LimitMaxError>"
$result+="    <LimitMaxWarning>100</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Usrv-DBStore Sproc Latency (msec)</channel>"
$result+="    <value>"+$value3.CookedValue+"</value>"
$result+="    <CustomUnit>ms</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>150</LimitMaxError>"
$result+="    <LimitMaxWarning>100</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Usrv-DBStore Throttled requests/sec</channel>"
$result+="    <value>"+$value4.CookedValue+"</value>"
$result+="    <CustomUnit>requests/sec</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Usrv-REGDBStore Queue Latency (msec)</channel>"
$result+="    <value>"+$value5.CookedValue+"</value>"
$result+="    <CustomUnit>ms</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>150</LimitMaxError>"
$result+="    <LimitMaxWarning>100</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Usrv-REGDBStore Sproc Latency (msec)</channel>"
$result+="    <value>"+$value6.CookedValue+"</value>"
$result+="    <CustomUnit>ms</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>150</LimitMaxError>"
$result+="    <LimitMaxWarning>100</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Usrv-REGDBStore Throttled requests/sec</channel>"
$result+="    <value>"+$value7.CookedValue+"</value>"
$result+="    <CustomUnit>requests/sec</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Usrv-SharedDBStore Queue Latency (msec)</channel>"
$result+="    <value>"+$value8.CookedValue+"</value>"
$result+="    <CustomUnit>ms</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>150</LimitMaxError>"
$result+="    <LimitMaxWarning>100</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Usrv-SharedDBStore Sproc Latency (msec)</channel>"
$result+="    <value>"+$value9.CookedValue+"</value>"
$result+="    <CustomUnit>ms</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>150</LimitMaxError>"
$result+="    <LimitMaxWarning>100</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Usrv-SharedDBStore Throttled requests/sec</channel>"
$result+="    <value>"+$value10.CookedValue+"</value>"
$result+="    <CustomUnit>requests/sec</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>SIP - Average Holding Time for Incoming Messages</channel>"
$result+="    <value>"+$value11.CookedValue+"</value>"
$result+="    <CustomUnit>ms</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>SIP - Incoming Messages Timed out</channel>"
$result+="    <value>"+$value12.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>4</LimitMaxError>"
$result+="    <LimitMaxWarning>2</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>SIP - Average outgoing Queue Delay</channel>"
$result+="    <value>"+$value13.CookedValue+"</value>"
$result+="    <CustomUnit>seconds</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>4</LimitMaxError>"
$result+="    <LimitMaxWarning>2</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>SIP - Flow-controlled Connections</channel>"
$result+="    <value>"+$value14.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>4</LimitMaxError>"
$result+="    <LimitMaxWarning>2</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>SIP - Average Incoming Message Processing Time</channel>"
$result+="    <value>"+$value15.CookedValue+"</value>"
$result+="    <CustomUnit>seconds</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>XMPPFederation - Failure IMDNs sent/sec</channel>"
$result+="    <value>"+$value16.CookedValue+"</value>"
$result+="    <CustomUnit>sent/sec</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>1</LimitMaxError>"
$result+="    <LimitMaxWarning>2</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>RoutingApps - Number of incoming failure responses</channel>"
$result+="    <value>"+$value17.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>CAA - Incomplete calls per sec</channel>"
$result+="    <value>"+$value18.CookedValue+"</value>"
$result+="    <CustomUnit>per-second</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>25</LimitMaxError>"
$result+="    <LimitMaxWarning>20</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>USrv - Create Conference Latency (msec)</channel>"
$result+="    <value>"+$value19.CookedValue+"</value>"
$result+="    <CustomUnit>ms</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>7000</LimitMaxError>"
$result+="    <LimitMaxWarning>5000</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>ASP.NET – Requests Rejected</channel>"
$result+="    <value>"+$value20.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>10</LimitMaxError>"
$result+="    <LimitMaxWarning>80</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Join Launcher - Join Failures</channel>"
$result+="    <value>"+$value21.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>WEB-Address Book File Download - Failed File Requests/Second</channel>"
$result+="    <value>"+$value22.CookedValue+"</value>"
$result+="    <CustomUnit>per-second</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>10</LimitMaxError>"
$result+="    <LimitMaxWarning>5</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>WEB-Address Book Web Query - Failed File Requests/Second</channel>"
$result+="    <value>"+$value23.CookedValue+"</value>"
$result+="    <CustomUnit>per-second</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>WEB - Failed validate cert calls to the cert auth provider</channel>"
$result+="    <value>"+$value24.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>WEB-Distribution List Expansion - Timed out Active Directory Requests/sec</channel>"
$result+="    <value>"+$value25.CookedValue+"</value>"
$result+="    <CustomUnit>per-second</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>ASMCU - MCU Health State</channel>"
$result+="    <value>"+$value26.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>4</LimitMaxError>"
$result+="    <LimitMaxWarning>2</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>AVMCU - MCU Health State</channel>"
$result+="    <value>"+$value27.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>4</LimitMaxError>"
$result+="    <LimitMaxWarning>2</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>DATAMCU - MCU Health State</channel>"
$result+="    <value>"+$value28.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>4</LimitMaxError>"
$result+="    <LimitMaxWarning>2</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>IMMCU - MCU Health State</channel>"
$result+="    <value>"+$value29.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>4</LimitMaxError>"
$result+="    <LimitMaxWarning>2</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>IMMCU - Throttled Sip Connections</channel>"
$result+="    <value>"+$value30.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Total failed calls caused by unexpected interaction from the Proxy</channel>"
$result+="    <value>"+$value31.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>15</LimitMaxError>"
$result+="    <LimitMaxWarning>10</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Total failed calls caused by unexpected interaction from a gateway</channel>"
$result+="    <value>"+$value32.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>15</LimitMaxError>"
$result+="    <LimitMaxWarning>10</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Health Indices - Load Call Failure Index</channel>"
$result+="    <value>"+$value33.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>15</LimitMaxError>"
$result+="    <LimitMaxWarning>10</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Media Relay - Candidates Missing</channel>"
$result+="    <value>"+$value34.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>Media Relay - Media Connectivity Check Failure</channel>"
$result+="    <value>"+$value35.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>2</LimitMaxError>"
$result+="    <LimitMaxWarning>1</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>SIP - Flow-controlled Connections</channel>"
$result+="    <value>"+$value36.CookedValue+"</value>"
$result+="    <unit>Count</unit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>150</LimitMaxError>"
$result+="    <LimitMaxWarning>100</LimitMaxWarning>"
$result+="  </result>"

$result+="  <result>"
$result+="    <channel>SIP - Average Incoming Message Processing Time</channel>"
$result+="    <value>"+$value37.CookedValue+"</value>"
$result+="    <CustomUnit>seconds</CustomUnit>"
$result+="    <mode>Absolute</mode>"
$result+="    <LimitMode>1</LimitMode>"
$result+="    <LimitMaxError>5</LimitMaxError>"
$result+="    <LimitMaxWarning>3</LimitMaxWarning>"


$result+="  </result>"

$result+="</prtg>"
write-host $result
# Clear $result
$result =""
