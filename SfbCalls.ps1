<#
.SYNOPSIS
Retrieves current connected clients, current active conference calls, inbound calls, outbound calls and total calls (inbound + outbound)

.DESCRIPTION
The SfbCalls.ps1 script gets the current values from your S4B FE server via counters. The XML output can be used as PRTG custom sensor.

.PARAMETER Server 
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
https://github.com/dylfen

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
        write-host "SIP Clients returned: " $value1.CookedValue }
        if($enableInboundCalls) {
        $value2 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Inbound Calls(_Total)\- Current" | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "Inbound calls returned: " $value2.CookedValue }
        if($enableOutboundCalls) {
        $value3 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Outbound Calls(_Total)\- Current" | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "Outbound calls returned: " $value3.CookedValue }
        if($enableTotalCalls) {
        $value4 = $value2.CookedValue + $value3.CookedValue
        write-host "Total calls (inbound + ourbound): " $value4 }
		if($enableActiveConfCalls) {
        $value5 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Pool Conference Statistics\USrv - Active Conference Count" | select -ExpandProperty CounterSamples)} -Credential $Credentials
        write-host "Active Conference Calls: " $value5.CookedValue }
    } else {
        $value1 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:SIP - Peers(Clients)\SIP - Connections Active" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
        $value2 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Inbound Calls(_Total)\- Current" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
        $value3 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:MediationServer - Outbound Calls(_Total)\- Current" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
        $value4 = $value2.CookedValue + $value3.CookedValue
        $value5 = Invoke-Command -Computername $server -ScriptBlock {(Get-Counter "\LS:USrv - Pool Conference Statistics\USrv - Active Conference Count" -ErrorAction silentlycontinue | select -ExpandProperty CounterSamples)} -Credential $Credentials
    }
	if ($error) {
        if($enableDebug){
        # Skip Counters
            write-host "Server: $server Unable to read $counter `r`n"
        }
		$error.clear()
	}
	else  {
        if($enableSipClients) {
            $result+="  <result>"
            $result+="    <channel>SIP Clients("+$server+")</channel>"
            $result+="    <value>"+$value1.CookedValue+"</value>"
            $result+="    <unit>Count</unit>"
            $result+="    <mode>Absolute</mode>"
            $result+="  </result>"
            }
        if($enableInboundCalls) {
            $result+="  <result>"
            $result+="    <channel>Inbound Calls("+$server+")</channel>"
            $result+="    <value>"+$value2.CookedValue+"</value>"
            $result+="    <unit>Count</unit>"
            $result+="    <mode>Absolute</mode>"
            $result+="  </result>"
        }
        if($enableOutboundCalls) {
            $result+="  <result>"
            $result+="    <channel>Outbound Calls("+$server+")</channel>"
            $result+="    <value>"+$value3.CookedValue+"</value>"
            $result+="    <unit>Count</unit>"
            $result+="    <mode>Absolute</mode>"
            $result+="  </result>"
        }
        if($enableTotalCalls) {
            $result+="  <result>"
            $result+="    <channel>Total Calls("+$server+")</channel>"
            $result+="    <value>"+$value4+"</value>"
            $result+="    <unit>Count</unit>"
            $result+="    <mode>Absolute</mode>"
            $result+="  </result>"
        }
        if($enableActiveConfCalls) {
            $result+="  <result>"
            $result+="    <channel>Active Conference Calls("+$server+")</channel>"
            $result+="    <value>"+$value5.CookedValue+"</value>"
            $result+="    <unit>Count</unit>"
            $result+="    <mode>Absolute</mode>"
            $result+="  </result>"
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
