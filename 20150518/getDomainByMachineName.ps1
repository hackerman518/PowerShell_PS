# $computer = $env:COMPUTERNAME
# $namespace = "ROOT\CIMV2"
# $classname = "Win32_OperatingSystem"

# Write-Output "====================================="
# Write-Output "COMPUTER : $computer "
# Write-Output "CLASS    : $classname "
# Write-Output "====================================="

# Get-WmiObject -Class $classname -ComputerName $computer -Namespace $namespace |
#     Select-Object * -ExcludeProperty PSComputerName, Scope, Path, Options, ClassPath, Properties, SystemProperties, Qualifiers, Site, Container |
#     Format-List -Property [a-z]*


# "ADPDS2768APP3Q0.ctp.dev.com".Split('.', 2)[1]

$localpcname = [System.Net.Dns]::GetHostByName("localhost").Hostname
# $FileExtension = [System.IO.FileInfo]::GetHostByName("localhost").Hostname
$Path = 'c:\temp\1.png'
get-item $path | Select-Object -Property Extension