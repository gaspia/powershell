$localRepo = "D:\UserData\z003m43e\Documents\source\ps1\processDiscovery\FileUploads\20200422_231049"
$remoteServer = "ec2-52-18-208-142.eu-west-1.compute.amazonaws.com"
$remotePath= "C:\Users\nice\Documents\nice-agent-uploads\"
$credential = Get-Credential

$uploadConfirm = Read-Host "Should the zip file be uploaded to $remoteServer (y/n)?"
    
if ($uploadConfirm -eq 'y') {
    #Set-SCPFile -ComputerName 'ec2-52-18-208-142.eu-west-1.compute.amazonaws.com' -Credential $credential -LocalFile $destZipFile -RemotePath 'C:\Users\nice\Documents\nice-agent-uploads\' -Force -Verbose -ConnectionTimeout 10000000
    Set-SCPFolder -ComputerName $remoteServer -Credential $credential -LocalFolder $localRepo -RemoteFolder $remotePath -Force -Verbose -ConnectionTimeout 1000000
    }   
