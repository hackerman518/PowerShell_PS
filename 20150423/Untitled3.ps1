$computer = $env:COMPUTERNAME
$namespace = "ROOT\DEFAULT"
$classname = "StdRegProv"

$HKLM = 2147483650
$KEY = "SOFTWARE\MICROSOFT\INTERNET EXPLORER"
$VALUE = "VERSION"
#$WMI = [wmiclass]"\\$COMPUTER\ROOT\DEFAULT:STDREGPROV"
#($WMI.GetStringValue($HKLM,$KEY,$VALUE)).sValue
#($WMI.GetStringValue($HKLM,$KEY,$VALUE))

$WMI = Get-WmiObject -Class $classname -ComputerName $computer | Invoke-WmiMethod 
#$WMI.ToString()