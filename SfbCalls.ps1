<#
.SYNOPSIS
Retrieves current connected clients, current active conference calls, inbound calls, outbound calls and total calls (inbound + outbound)

.DESCRIPTION
The SfbCalls.ps1 script gets the current values from your S4B FE server via counters. The XML output can be used as PRTG custom sensor.

.PARAMETER Server (requirement)
Represents the server you will connect to. HOSTNAME or IP

.PARAMETER Username (requirement)
Represents the username for authentication to the server

.PARAMETER Password (requirement)
Represents the password for authentication to the server

.SETTINGS
Debug - Enable or disable added debug info
$enableDebug =          $false or $true

Disable unwanted stats set to $false
$enableSipClients 
$enableInboundCalls 
$enableOutboundCalls 
$enableTotalCalls
$enableActiveConfCalls 

.EXAMPLE
Retrieves counters from SFB FE server.
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
https://gitlab.com/dylfen/

#>
    
param (
    [string]$server= "",
    [string]$username= "",
    [string]$password= "" 
)

	
#Debug - $true or $false
$enableDebug =          $false

# Enable Channels - $true or $false
$enableSipClients =     $true
$enableInboundCalls =   $true
$enableOutboundCalls =  $true
$enableTotalCalls =     $true
$enableActiveConfCalls =$true
$enableConfPaticipants =$true
$enableActiveRegEndp =	$true
$enableActiveRegUsers =	$true



$SecPasswd = ConvertTo-SecureString $Password -AsPlainText -Force 
$Credentials= New-Object System.Management.Automation.PSCredential ($Username, $secpasswd) 

if($enableDebug){
    write-host "Start PRTG Sensor`r`n" 
    write-host "Server(s): $Server `r`n"
}
$serverlist = $server.split(",")
$serverCount = $Serverlist.count
if($enableDebug){
    write-host "Serverlist count: $serverCount `r`n" 
}
$result='<?xml version="1.0" encoding="UTF-8" ?><prtg>'

foreach ($server in $serverlist){
    if($enableDebug){
        write-host "Getting counters from server:  $server `r`n"
        if($enableSipClients) {
        $value1 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Peers(Clients)\SIP - Connections Active"  | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "SIP Clients returned: " $value1.CookedValue " `r`n"}
        if($enableInboundCalls) {
        $value2 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Inbound Calls(_Total)\- Current" | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "Inbound calls returned: " $value2.CookedValue " `r`n"}
        if($enableOutboundCalls) {
        $value3 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Outbound Calls(_Total)\- Current" | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "Outbound calls returned: " $value3.CookedValue " `r`n"}
        if($enableTotalCalls) {
        $value4 = $value2.CookedValue + $value3.CookedValue
        write-host "Total calls (inbound + ourbound): " $value4 " `r`n"}
		if($enableActiveConfCalls) {
        $value5 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Pool Conference Statistics\USrv - Active Conference Count" | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "Active Conference Calls: " $value5.CookedValue " `r`n"}
		if($enableConfPaticipants) {
        $value6 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Pool Conference Statistics\USrv - Active Participant Count" | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "Active Conference Paticipants: " $value6.CookedValue " `r`n"}
		if($enableActiveRegEndp) {
        $value7 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Endpoint Cache\USrv - Active Registered Endpoints" | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "Active Registered Endpoints: " $value7.CookedValue " `r`n"}
		if($enableActiveRegUsers) {
        $value8 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Endpoint Cache\USrv - Active Registered Users" | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "Active Registered Users: " $value8.CookedValue " `r`n"}
    } else {
        if($enableSipClients) 		{ $value1 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Peers(Clients)\SIP - Connections Active" -ErrorAction silentlycontinue  | select -ExpandProperty CounterSamples)} -Credential $Credentials }
		if($enableInboundCalls) 	{ $value2 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Inbound Calls(_Total)\- Current" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials }
		if($enableOutboundCalls) 	{ $value3 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Outbound Calls(_Total)\- Current" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials }
		if($enableTotalCalls) 		{ $value4 = $value2.CookedValue + $value3.CookedValue }
		if($enableActiveConfCalls) 	{ $value5 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Pool Conference Statistics\USrv - Active Conference Count" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials }
		if($enableConfPaticipants) 	{ $value6 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Pool Conference Statistics\USrv - Active Paticipant Count" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials }
		if($enableActiveRegEndp) 	{ $value7 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Endpoint Cache\USrv - Active Registered Endpoints" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials }
		if($enableActiveRegUsers) 	{ $value8 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Endpoint Cache\USrv - Active Registered Users" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials }
    }

	if ($error) {
        if($enableDebug){
        # Skip Counters
            write-host "Server: $server Unable to read one or more counter(s) `r`n"
        }
		$error.clear()
	}
	else  {
        if($enableSipClients) {
            $result+="  <result>`r`n"
            $result+="    <channel>SIP Clients("+$server+")</channel>`r`n"
            $result+="    <value>"+$value1.CookedValue+"</value>`r`n"
            $result+="    <unit>Count</unit>`r`n"
            $result+="    <mode>Absolute</mode>`r`n"
            $result+="  </result>`r`n"
            }
        if($enableInboundCalls) {
            $result+="  <result>`r`n"
            $result+="    <channel>Inbound Calls("+$server+")</channel>`r`n"
            $result+="    <value>"+$value2.CookedValue+"</value>`r`n"
            $result+="    <unit>Count</unit>`r`n"
            $result+="    <mode>Absolute</mode>`r`n"
            $result+="  </result>`r`n"
        }
        if($enableOutboundCalls) {
            $result+="  <result>`r`n"
            $result+="    <channel>Outbound Calls("+$server+")</channel>`r`n"
            $result+="    <value>"+$value3.CookedValue+"</value>`r`n"
            $result+="    <unit>Count</unit>`r`n"
            $result+="    <mode>Absolute</mode>`r`n"
            $result+="  </result>`r`n"
        }
        if($enableTotalCalls) {
            $result+="  <result>`r`n"
            $result+="    <channel>Total Calls("+$server+")</channel>`r`n"
            $result+="    <value>"+$value4+"</value>`r`n"
            $result+="    <unit>Count</unit>`r`n"
            $result+="    <mode>Absolute</mode>`r`n"
            $result+="  </result>`r`n"
        }
        if($enableActiveConfCalls) {
            $result+="  <result>`r`n"
            $result+="    <channel>Active Conference Calls("+$server+")</channel>`r`n"
            $result+="    <value>"+$value5.CookedValue+"</value>`r`n"
            $result+="    <unit>Count</unit>`r`n"
            $result+="    <mode>Absolute</mode>`r`n"
            $result+="  </result>`r`n"
        }
		if($enableConfPaticipants) {
            $result+="  <result>`r`n"
            $result+="    <channel>Active Conference Paticipants("+$server+")</channel>`r`n"
            $result+="    <value>"+$value6.CookedValue+"</value>`r`n"
            $result+="    <unit>Count</unit>`r`n"
            $result+="    <mode>Absolute</mode>`r`n"
            $result+="  </result>`r`n"
        }
		if($enableActiveRegEndp) {
            $result+="  <result>`r`n"
            $result+="    <channel>Active Registered Endpoints("+$server+")</channel>`r`n"
            $result+="    <value>"+$value7.CookedValue+"</value>`r`n"
            $result+="    <unit>Count</unit>`r`n"
            $result+="    <mode>Absolute</mode>`r`n"
            $result+="  </result>`r`n"
        }
		if($enableActiveRegUsers) {
            $result+="  <result>`r`n"
            $result+="    <channel>Active Registered Users("+$server+")</channel>`r`n"
            $result+="    <value>"+$value8.CookedValue+"</value>`r`n"
            $result+="    <unit>Count</unit>`r`n"
            $result+="    <mode>Absolute</mode>`r`n"
            $result+="  </result>`r`n"
        }
	}
}

$result+="</prtg>"
if($enableDebug){
    write-host "End: ExitCode " $error.count " `r`n"
    Write-host "Sending Result to output pipeline`r`n"
}
write-host $result
# Clear $result
$result =""

if ($error) {
    if($enableDebug){
        write-host "Found Errors`r`n"
    }
	EXIT 1
}
