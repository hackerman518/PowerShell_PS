$computer
$localpcname = [System.Net.Dns]::GetHostByName("localhost").Hostname
"\\"$localpcname"\C$\Users\tliu\Downloads\AdventDirectAgentSetup_Firm5005_15_05_0_461.exe"
([WMICLASS]"\\$computer\ROOT\CIMV2:Win32_Process").Create($InstallString) | Out-File -FilePath c:\installed.txt -Append -InputObject "$computer"