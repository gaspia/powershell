$source = "D:\UserData\z003m43e"
$localRepo = "D:\UserData\z003m43e\Documents\source\ps1\processDiscovery\FileUploads"
$fileDate = $(get-date)
$remoteServer = "ec2-52-18-208-142.eu-west-1.compute.amazonaws.com"
$remotePath= "C:\Users\nice\Documents\nice-agent-uploads\20200422" #+ "\" + $((Get-Date).ToString('yyyyMMdd_HHmmss'))

$newRepoFolder = $localRepo + "\" + $((Get-Date).ToString('yyyyMMdd_HHmmss'))

Write-Host "Creating local repo folder:" + $newRepoFolder
New-Item -ItemType Directory -Path  $newRepoFolder

write-host "Compressing all JSON files from NICE clients (AutomationFinder) folders, created before " $fileDate.ToString("yyyy-MM-dd")
# Upload to server question and creds
$uploadConfirm = Read-Host "Should the zip file be uploaded to $remoteServer (y/n)?"
$credential = Get-Credential

$folderCollection = Get-ChildItem -Path $source -Recurse -directory | Where-Object {$_.FullName -like '*AutomationFinder *'}
#Write-Host $folderCollection
#$regRex = '\[\s(\(\d\))]\g'

ForEach ($folder in $folderCollection) {
    Write-Host "Zipping JSON filed in $folder"
    $fileCounter = 0
    $cleanFolderName = $folder.Name.Replace("AutomationFinder ","")
    $cleanFolderName = $cleanFolderName.Replace(" ", "")
    $cleanFolderName = $cleanFolderName.Replace("(", "")
    $cleanFolderName = $cleanFolderName.Replace(")", "")
    #Write-Host "Clean file path:" + $cleanFolderName
    Do  {
        $destZipFile = $newRepoFolder + "\" + $fileDate.AddDays(-1).ToString("yyyMMdd") + "_" + $fileCounter + "_" +  $cleanFolderName + ".zip"
        $fileCounter++    
    } While (Test-Path $destZipFile)
    Write-Host "Destination ZIP file: " $destZipFile
    #$captureFiles= Get-ChildItem -path $folder.FullName -Recurse -include *.json | where-object {$_.lastwritetime -lt $fileDate} | where-object {-not $_.PSIsContainer} | Foreach-Object { $_.FullName+"`n"}

    #zipping JSON files
    Get-ChildItem -path $folder.FullName -Recurse -include *.json | where-object {$_.lastwritetime -lt $fileDate} | where-object {-not $_.PSIsContainer} | Foreach-Object { $_.FullName} | Compress-Archive -DestinationPath $destZipFile
    #uploading to server
    if ($uploadConfirm -eq 'y') {
        Set-SCPFile -ComputerName 'ec2-52-18-208-142.eu-west-1.compute.amazonaws.com' -Credential $credential -LocalFile $destZipFile -RemotePath $remotePath -Force -Verbose -ConnectionTimeout 1000000
        }      
    }
    
 



