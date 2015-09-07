function unzip ($zipFilePath, $targetDir) {
  # load Ionic.Zip.dll
  [System.Reflection.Assembly]::LoadFrom(d:\Ionic.Zip.dll)
  $encoding = [System.Text.Encoding]::GetEncoding("utf-8") 
  $zipfile =  new-object Ionic.Zip.ZipFile($encoding)
 
  if (!(test-path (split-path $targetDir -parent))) {
    mkdir (split-path $targetDir -parent)
  }
  write-host "Extracting... zip file[$zipFilePath] to $targetDir"
  $zip = [Ionic.Zip.ZIPFile]::Read($zipFilePath, $encoding)
  $zip | %{$_.Extract($targetDir, [Ionic.Zip.ExtractExistingFileAction]::OverWriteSilently)}
  write-host "Extracted."
}