param
(
    [Parameter(Mandatory=$true)][string]$shareLocation,
    [Parameter(Mandatory=$true)][string]$firmID,
    [Parameter(Mandatory=$true)][int]$workflowInstanceId
)

Write-Host "Begin conversion script $scriptName."
Try
{
    # Import functions to the current session.
    $scriptPath = split-path -parent $PSCommandPath	 # Get this script's full path.
    . "$scriptPath\APDSDownloadFunctionsLib.ps1"

    # Use this for local execution for developers
    #$load = "$scriptPath\..\..\Backend\PowerShellScripts\LoadBusinessLayer.ps1"

    # Make sure the above $load is commented out and bottom one uncommented before check-in.
    $load = "$scriptPath\..\CommonScripts\LoadBusinessLayer.ps1"

    # Execute the following script to load dependencies which must be in the relative path as this script.
    & $load

    $scriptName = $MyInvocation.MyCommand.Name

    $ps = [Advent.PDS.BusinessCommon.Master.PowerShell]
    $dataFileInfoType = [Advent.PDS.BusinessCommon.DataServiceProxy.DataFileInfo]

    # Get all the acquired files for the given workflow instance ID that produced the files.
    # Only original files that have been acquired.
    # DataFileTypeId 1 is equal to Original file. 
    # DataFileStatusId 2 is equal to Acquired file. 
    $arguments = ('$filter' + "=WorkflowInstanceId eq $workflowInstanceId and DataFileTypeId eq 1 and DataFileStatusId eq 2"), 'DataFileInfos'
    $fileInfos = $ps.GetMethod('GetEntities').MakeGenericMethod($dataFileInfoType).Invoke($dataFileInfoType, $arguments)

    if ($fileInfos.Count -gt 0)
    {
        $ctx = [Advent.PDS.BusinessCommon.Master.BusinessLayer]::GetNewContext()
    }
    else
    {
        Write-Host "Zero files returned for Data Conversion."
        exit
    }


	# Get random name for folder location where files will be dumped.
    $outPath = [System.IO.Path]::GetFileNameWithoutExtension([System.IO.Path]::GetRandomFileName())

    # Create the folder (pipe to null so it's not sent to StandardOutput)
    New-Item -ItemType Directory -Force -Path $outPath > $null

    # Create array with all the file Ids.
    foreach ($fileInfo in $fileInfos)
    {
        # Acquire file with the specified DataFileInfoId.
	    Try
	    {
            DownloadDataFiles $outPath $fileInfo.DataFileInfoId
	    }
	    Catch
	    {
            Write-Error "DownloadDataFiles encountered an error downloading file with id:" $fileInfo.DataFileInfoId
        
            # Wait one second to allow the agent job runner to encapsulate all information written to standard error as one block.
            Wait-Event -Timeout 1

            continue
        }

        # Get the name without extension
        Write-Output "test output";
       
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileInfo.Name)
        Write-Output "Here get the original base name as: " $baseName.ToString();
        $newname = ''
        $filename = $fileInfo.Name
        Write-Output "Here get the original file name as: " $fileInfo.Name;
        # Rename to appropriate file extension based on keyword in the file name.
        if ($baseName.Contains('POSIT'))
        {
            # Expect format: 10087POSIT20121204_043052.txt
            # Rename to 1Lmmddyy.ps1
            $newname = '1L' + $baseName.Substring(14,4) + $baseName.Substring(12,2) + '.ps1'
            Write-Output "Here get the New Name in POSIT type as: " $newname;

            Write-Output "Update Processed FileTypeId" $fileInfo.name;
            $fileInfo.ProcessedFileTypeID = 'PSX'
            $fileInfo.BusinessDate = (get-date).ToString("yyyy-MM-dd")
            #ToString("MM/dd/yyyy hh:mm:ss")
        }
        elseif ($baseName.Contains('TRANS'))
        {
            # Expect format: 10087_TRANS_20121204_LOC.TXT
            # Rename to 1Lmmddyy.tr1
            $newname = '1L' + $baseName.Substring(16,4) + $baseName.Substring(14,2) + '.tr1'
            Write-Output "Here get the New Name in TRANS type as: " $newname;

            Write-Output "Update Processed FileTypeId" $fileInfo.name;
            $fileInfo.ProcessedFileTypeID = 'TRX'
            $fileInfo.BusinessDate = (get-date).ToString("yyyy-MM-dd")
        }
        
        if ($newname -ne '')
        {
            rename-item (Join-Path $outPath $fileInfo.Name) -newname $newname
            $filename = $newname
            Write-Output "Here rename the newname " $newname;
        }

        # Upload it the database.
#        $filename = Join-Path $outPath $filename
        Try
	    {
            Write-Output "Begin upload to the database";
            # FileType 3 is "Pre-Translated"
            # FileStatus 3 is "Ready for processing"
            $fileId = RegisterFTPFile (Join-Path $outPath $filename) 3 $fileInfo.DataFileInfoId (Get-Date -format MM/dd/yyyy) 3
            Write-Output "Here successfully get the fileId as: " $fileId;
	    }
	    Catch
	    {
            Write-Error "Uploading file to db encountered an error. File id:" $fileInfo.DataFileInfoId
        
            # Wait one second to allow the agent job runner to encapsulate all information written to standard error as one block.
            Wait-Event -Timeout 1

            continue
        }

        if ($fileId -gt 0)
        {
            Write-Host "File: $filename uploaded successfully with file ID:" $fileId
        }
        else
        {
            Write-Error "File: $filename failed to uploaded."
            
            # Wait one second to allow the agent job runner to encapsulate all information written to standard error as one block.
            Wait-Event -Timeout 1
        }
        Write-Output "Here successfully uploaded and begin to change the parent file status to 3";
        # If file was successfully uploaded, set the parent file status to 3 ?Ready for processing (maybe temp)
        # so we don't convert it next time
        $fileInfo.DataFileStatusId = 3
        Write-Output "Begin to attach:" $fileinfo.ToString();
        $ctx.AttachTo('DataFileInfos', $fileInfo)
         Write-Output "Update Object:" $fileinfo.ToString();
        $ctx.UpdateObject($fileInfo)
         Write-Output "Write Host:" $fileInfo.Name;
        Write-Host "File " $fileInfo.Name " (file id: " $fileInfo.DataFileInfoId ") is converted to $filename (file id: " $fileId ")."
    }

    # Push file name updates to database in batch.
    if ($fileInfos.Count -gt 0)
    {
        # Pipe the result of SaveChanges() to null so that it's not send to StandardOutput
        $ctx.SaveChanges([System.Data.Services.Client.SaveChangesOptions]::Batch) > $null
    }
}
Catch [System.Exception]
{
    Write-Error $_.Exception
}

Catch
{
	Write-Error $_
	return 0
}

Finally
{
    Write-Debug "Remove the temporary folder and all items from it";
    # Remove the temporary folder and all items from it.
    If ($outPath -ne $null)
    {
        If(Test-Path $outPath)
        {
            Remove-Item .\$outPath -Force -Recurse
        }
    }

    Write-Host "End of conversion script $scriptName."

    Write-Debug "Debug-Finish";
}
