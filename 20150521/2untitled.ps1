########################################
# Webdav Upload with Powershell
########################################

# Absolute path to file
#$file="D:\text.txt"
$file = $Result.Path;
# URL no trailing "/"
$url = "https://webdav.synapse.com/Disney/beakerdata"

# Username and Password
$user = ""
$pass = ""



########################################
# Script
#######################################

# Append the name of the file onto the url
$url += "/" + $file.split('\')[(($file.split("\")).count - 1)]

    

########################################
# Begin prepare file data
#######################################

#Write-Host "File upload started"

# Set as binary data
Set-Variable -name adFileTypeBinary -value 1 -option Constant

$objADOStream = New-Object -ComObject ADODB.Stream
$objADOStream.Open()
$objADOStream.Type = $adFileTypeBinary
$objADOStream.LoadFromFile("$file")
$arrbuffer = $objADOStream.Read()

########################################
# End prepare file data
#######################################



########################################
# Begin WebDav connection and PUT
#######################################

$objXMLHTTP = New-Object -ComObject MSXML2.ServerXMLHTTP.6.0
$objXMLHTTP.setOption(2,13056) # Ignore ceriticate errors
$objXMLHTTP.Open("PUT", $url, $False, $user, $pass)
$objXMLHTTP.send($arrbuffer)

# This will give you the response text
# $objXMLHTTP.responseText

# Verify upload
if ($objXMLHTTP.status -eq 201) { 
# Write-Host "File upload finished"
$Result.RetMsg = "File upload finished"
}

elseif ($objXMLHTTP.status -eq 204) { 
#Write-Host = "File already exists"
$Result.RetMsg ="File already exists"
}
