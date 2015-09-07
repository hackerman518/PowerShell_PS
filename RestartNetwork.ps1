Param
(
    [Parameter(Mandatory=$true)][int]$sleeptime
)

Get-WmiObject win32_networkadapter |Where-Object -Property NetEnabled -EQ 'True' |Format-Table -AutoSize

$NetworkDev = Get-WmiObject win32_networkadapter |Where-Object -Property NetEnabled -EQ 'True'

Write-Host "BE CAREFULL!"
Write-Host ($NetworkDev|measure).Count "Network device(s) of" $NetworkDev.Pscomputername "will be disable and enabled?"

[string] $confirm = $( Read-Host "Sleep " $sleeptime " [seconds] between network disable and enabled. Enter 'YES' to continue " )

if ($confirm -eq 'YES')
{

Write-Host "Start to Disable network"
#$NetworkDev.disable()

sleep $sleeptime 

Write-Host "Start to Enable network"
#$NetworkDev.enable()
Write-Host "Welcome Back!"
}