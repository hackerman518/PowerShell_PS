param
(
  [string]$pcName = "pcName",
  [string]$loginUser = "administrator",
  [string]$loginPassword = "loginPwd"

)

$authCmd = "PsExec \\" + $pcName + " -u " + $loginUser + " -p " + $loginPassword + " PowerShell "
$authCmd + "Enable-PSRemoting -Force"
$authCmd + "Get-Item WSMan:\localhost\Client\TrustedHosts"
$authCmd + "Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force"
