# -----
# Scripts unpins certain programs from the taskbar
# Uses https://gallery.technet.microsoft.com/ScriptCenter/b66434f1-4b3f-4a94-8dc3-e406eb30b750/
# -----

# Find where Powershell modules kept 
$psPath = $env:PSModulePath.Split(";")
$psPath.Get(0)

# Copy pinApplication module and import it for use
Copy-Item "\\VBOXSVR\vagrant\Scripts\pinApplication\" -Destination $psPath.Get(0) -Recurse -ErrorAction SilentlyContinue
Import-Module pinApplication 


# Try to unpin the programs
# If not found, terminal error will be found so catch it and carry on
try {
    Set-PinnedApplication -Action UnPinFromTaskbar -FilePath "C:\Windows\System32\ServerManager.exe"
}
Catch {
    Write-Host Servermanager was not unpinned/found
}

try {
    Set-PinnedApplication -Action UnPinFromTaskbar -FilePath "C:\Program Files (x86)\Atlassian\SourceTree\SourceTree.exe"
}
Catch {
    Write-Host SourceTree was not unpinned/found
}

try {
    Set-PinnedApplication -Action UnPinFromTaskbar -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
}
Catch {
    Write-Host Powershell was not unpinned/found
}

$Name = $MyInvocation.MyCommand.Name
Write-Host $Name "done"