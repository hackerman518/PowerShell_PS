<#


#>


param (
  [Parameter(Mandatory = $false)]
  [string]$hostname = $env:COMPUTERNAME
  #[bool]$Not

)

#Enable-PSRemoting
#Set-ExecutionPolicy RemoteSigned

# Main code here
Get-CimInstance -ComputerName $hostname -ClassName Win32_LogicalDisk -Filter "DeviceId='c:'" |
Select-Object `
   @{ n = "Name"; e = { $_.Name } },`
   @{ n = "FreeGB"; e = { $_.FreeSpace / 1gb -as [int] } } | Format-Table -AutoSize

