$ieVersion = New-Object -TypeName System.Version -ArgumentList (
    Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Internet Explorer').Version
$ieVersion = New-Object -TypeName System.Version -ArgumentList (
    # switch major and minor
    $ieVersion.Minor, $ieVersion.Major, $ieVersion.Build, $ieVersion.Revision)
if ($ieVersion.Major -lt 11)
{
    Write-Error "Internet Explorer 11 or later required. Current IE version is $ieVersion"
    exit
}


#################


#PARAM([STRING]$COMPUTER = $ENV:COMPUTERNAME)
param([string]$COMPUTER = $ENV:COMPUTERNAME)
$HKLM = 2147483650
$KEY = "SOFTWARE\MICROSOFT\INTERNET EXPLORER"
$VALUE = "VERSION"
$WMI = [wmiclass]"\\$COMPUTER\ROOT\DEFAULT:STDREGPROV"
#($WMI.GetStringValue($HKLM,$KEY,$VALUE)).sValue
#($WMI.GetStringValue($HKLM,$KEY,$VALUE))a



#(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Internet Explorer').Version
(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Internet Explorer').svcVersion

#################

$array =@() 
$keyname = 'SOFTWARE\\Microsoft\\Internet Explorer' 
$computernames = "localhost"
foreach ($server in $computernames) 
{ 
$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $server) 
$key = $reg.OpenSubkey($keyname) 
$value = $key.GetValue('Version') 
 $obj = New-Object PSObject 
         
        $obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $server 
         
        $obj | Add-Member -MemberType NoteProperty -Name "IEVersion" -Value $value 
 
        $array += $obj  
 
 
} 
 
$array | select ComputerName,IEVersion | export-csv IE_Version.csv

#################

#################

#################

#################