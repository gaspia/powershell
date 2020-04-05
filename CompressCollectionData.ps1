"
#Script to zip backup NICE Automation Finder capture files
#
$source = <Path to root dir>
$fileDate = $(get-date).AddDays(-1)

write-host "Compressing all JSON files from NICE clients (AutomationFinder) folders, created on " $fileDate.AddDays(-1).ToString("yyyy-MM-dd")

$folderCollection = Get-ChildItem -Path $source -Recurse -directory | Where-Object {$_.FullName -like '*AutomationFinder*'}

ForEach ($folder in $folderCollection) {
    
    $fileCounter = 0
    
    Do  {
        $destZipFile = $folder.FullName + "\" + $fileDate.AddDays(-1).ToString("yyyMMdd") + "_" + $fileCounter + "_" + $folder.Name.Replace("AutomationFinder ","") + ".zip"
        $fileCounter++    
    } While (Test-Path $destZipFile)
    
    $captureFiles= Get-ChildItem -path $folder.FullName -Recurse -include *.json | where-object {$_.lastwritetime -lt (get-date)} | where-object {-not $_.PSIsContainer} | Foreach-Object { $_.FullName+"`n"} 
    Write-Host $captureFiles
    $zipConfirm = Read-Host "Should I zip the files above into " $destZipFile "(y/n)?"
    
    if ($zipConfirm -eq 'y') {
        Get-ChildItem -path $folder.FullName -Recurse -include *.json | where-object {$_.lastwritetime -lt (get-date)} | where-object {-not $_.PSIsContainer} | Foreach-Object { $_.FullName} | Compress-Archive -DestinationPath $destZipFile
    
        $deleteConfirm = Read-Host "Should I delete the orginal files(y/n)?"
    
        if ($zipConfirm -eq 'y') {
            Get-ChildItem -path $folder.FullName -Recurse -include *.json | where-object {$_.lastwritetime -lt (get-date)} | where-object {-not $_.PSIsContainer} | Foreach-Object { Remove-Item -path $_.FullName -force}
            }
    
        }
    
    }


