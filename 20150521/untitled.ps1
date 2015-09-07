# Script to import AdventSTS.pfx and AdventDirectST.pfx keys 
# into local key stores so they can be used by Advent software.
# 
# Author: Bevan Kling, Richard Mills
#

param
(
    [String] $AdventATCPfx = $(throw "Please supply a AdventStsPfx file name"),
    [string] $ATCPassword = $(throw "Please supply a StsPassword for STS key")
)
    

function Import-PfxCertificateSTSmy
{
$certStore = “my”
$certRootStore = “LocalMachine”
$certPath = $AdventATCPfx # "z:\wildcard.ctp.dev.com.pfx"
$pfxPass = $ATCPassword
$pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2
$pfx.import($certPath,$pfxPass,“Exportable,PersistKeySet”)
$store = new-object System.Security.Cryptography.X509Certificates.X509Store($certStore,$certRootStore)
$store.open(“MaxAllowed”)
$store.add($pfx)
$store.close()
}

Import-PfxCertificateSTSmy


param
(
    [String] $AcdApiPfx = $(throw "Please supply a AcdApiPfx file name"),
    [string] $PfxPassword = $(throw "Please supply a PfxPassword")
)
    
$certStore = “root”
$certRootStore = “LocalMachine”
$certPath = $AcdApiPfx 
$pfxPass = $PfxPassword 
$pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2
$pfx.import($certPath,$pfxPass,“Exportable,PersistKeySet”)
$store = new-object System.Security.Cryptography.X509Certificates.X509Store($certStore,$certRootStore)
$store.open(“MaxAllowed”)
$store.add($pfx)
$store.close()