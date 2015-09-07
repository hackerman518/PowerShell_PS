param
(
  [Parameter(Mandatory = $true)] [int]$sInput = $(throw "Please supply a date with yyyyMMdd")

)



#Get-ChildItem | ForEach-Object -Process { Rename-Item $_.FullName($_.Name.Split("_")[0] + "_" + $sInput + $_.Name.Split("_")[1].Substring(8)) }
#Get-ChildItem | ForEach-Object -Process { $_.LastWritetime = Get-Date }
#Get-ChildItem | select -Property Name

#$sInput = 20141105
Get-ChildItem | ForEach-Object -Process { Rename-Item $_.FullName($_.Name.Split("_")[0] + "_" + $sInput + $_.Name.Split("_")[1].Substring(8)) }
Get-ChildItem | ForEach-Object -Process { $_.LastWritetime = Get-Date }
Get-ChildItem | Select-Object -Property Name
