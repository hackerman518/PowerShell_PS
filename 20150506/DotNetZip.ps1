## - Beginning of Script:
Function New-ZipFile{
PARAM
(
[String] $SrcFolder,
[String] $DestFolder,
[string] $DestZipName,
[String] $FileExtToZip,
[string] $ZipPurpose,
[string] $StoredInZipFolder,
[string] $DeleteFiles = $null
)
#$TodaysDate = Get-Date -uformat "%Y-%m-%d-%Hh%Mm%Ss.zip";
#$ZipFileName = $ZipPurpose + "_" +$DestZipName + "_" + $TodaysDate;
$ZipFileName = $ZipPurpose + "_" +$DestZipName + ".zip";
 
if (Test-Path $DestFolder){
## - Create Zip file or it won't work:
if (Test-Path ($DestFolder+"\"+$ZipFileName)) { del ($DestFolder+"\"+$ZipFileName) }
new-item ($DestFolder+"\"+$ZipFileName) -ItemType File
}
else
{
Write-Host "Destination Folder [$DestFolder] doesn't exist" -ForegroundColor 'Yellow';
Break;
};
 
## - Loads the Ionic.Zip assembly:
[System.Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\DotNetZip\Ionic.Zip.dll") |
 
out-null;
$zipfile = new-object Ionic.Zip.ZipFile
 
## - AddSelectedFiles with source folder path:
## - ($false grab files in source folder) & ($true grab files & subfolder files)
$zipfile.AddSelectedfiles($FileExtToZip,$SrcFolder,$true) | Out-Null;
## - UseZip64WhenSaving, when needed, will create a temp file compress large number of files:
$Zipfile.UseZip64WhenSaving = 'AsNecessary'
$zipfile.Save($DestFolder+"\"+$ZipFileName)
$zipfile.Dispose()
 
If ($DeleteFiles.ToUpper() -eq 'YES'){
## - Remove all backed up files:
Write-Host "Deleting files after zip!";
get-childitem ($SrcFolder+"\"+$FileExtToZip) | remove-item
}
};
 
### - variables:
$DestZipName = "BackupMyTempSSIS";
$FileExtToZip = "name = *.*";
$DestFolder = "C:\MyBackupZipFolder";
$SrcFolder = "C:\TempSSIS";
$DeleteFiles = $null;
$StoredInZipFolder = "MyBackupZip\";
$ZipPurpose = "BackUp";
#or $ZipPurpose = "Save";
 
New-ZipFile -DeleteFiles $DeleteFiles `
-DestFolder $DestFolder -DestZipName $DestZipName `
-FileExtToZip $FileExtToZip -SrcFolder $SrcFolder `
-StoredInZipFolder $StoredInZipFolder -ZipPurpose $ZipPurpose;
 
## - End of Script