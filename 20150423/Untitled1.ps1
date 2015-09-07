#PARAM([STRING]$COMPUTER = $ENV:COMPUTERNAME)
param([string]$COMPUTER = $ENV:COMPUTERNAME)
$HKLM = 2147483650
$KEY = "SOFTWARE\MICROSOFT\INTERNET EXPLORER"
$VALUE = "VERSION"
$WMI = [wmiclass]"\\$COMPUTER\ROOT\DEFAULT:STDREGPROV"
#($WMI.GetStringValue($HKLM,$KEY,$VALUE)).sValue
#($WMI.GetStringValue($HKLM,$KEY,$VALUE))
#(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Internet Explorer').Version


(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Internet Explorer').svcVersion

