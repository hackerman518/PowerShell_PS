http://blog.csdn.net/ffeiffei/article/details/5948890


#####
Write-Host "---------------华丽的分割线------------------"
function OTR () {
  $ts = Get-WmiObject Win32_TerminalServiceSetting -Namespace ROOT\CIMV2\TerminalServices
  $r = $ts.AllowTSConnections
  if ($r -eq 1)
  {
    Write-Host "远程桌面处于开启状态,无需重复开启"
  } else {
    $ts.SetAllowTSConnections(1) | Out-Null
    Write-Host "远程桌面开启成功"
  }
}
function CTR () {
  $ts = Get-WmiObject Win32_TerminalServiceSetting -Namespace ROOT\CIMV2\TerminalServices
  $r = $ts.AllowTSConnections
  if ($r -eq 0)
  {
    Write-Host "远程桌面处于关闭状态,无需重复关闭"
  } else {
    $ts.SetAllowTSConnections(0) | Out-Null
    Write-Host "远程桌面关闭成功"
  }
}
#查看状态
function STR () {
  $ts = Get-WmiObject Win32_TerminalServiceSetting -Namespace ROOT\CIMV2\TerminalServices
  $r = $ts.AllowTSConnections
  if ($r -eq 0)
  {
    Write-Host "远程桌面处于[关闭]状态"
  }
  if ($r -eq 1)
  {
    Write-Host "远程桌面处于[开启]状态"
  }
}
#End查看状态
#输入控制
function CustOrderSW () {
  $ins = Read-Host "输入命令"
  switch ($ins) {
    (0)
    { CTR
      CustOrderSW;
      break }
    (1)
    {
      OTR
      CustOrderSW;
      break
    }
    (2)
    {
      STR
      CustOrderSW;
      break }
    default {
      "不存De命令"
      CustOrderSW;
      break
    }
  }
}
#end输入控制
#调用自定义函数
CustOrderSW

###