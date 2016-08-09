# 1 - Used to create DM 
$IEFav = [Environment]::GetFolderPath('Favorites', 'None') 
$Shell = New-Object -ComObject WScript.Shell
$IEFav = Join-Path -Path $IEFav -ChildPath 'Links'
$Name = 'DM'
$FullPath = Join-Path -Path $IEFav -ChildPath "$($Name).url"
$url = 'http://localhost:80/dm/dm.do'

$shortcut = $Shell.CreateShortcut($FullPath)
$shortcut.TargetPath = $url
$shortcut.Save()

# 2 - Used to create JFinder 
$Name = 'JFinder'
$FullPath = Join-Path -Path $IEFav -ChildPath "$($Name).url"
$url = 'http://localhost:8080/jfinder'

$shortcut = $Shell.CreateShortcut($FullPath)
$shortcut.TargetPath = $url
$shortcut.Save()

# 3 - Used to create BPM 
$Name = 'BPM'
$FullPath = Join-Path -Path $IEFav -ChildPath "$($Name).url"
$url = 'http://localhost:8180/bpm'

$shortcut = $Shell.CreateShortcut($FullPath)
$shortcut.TargetPath = $url
$shortcut.Save()

$Name = $MyInvocation.MyCommand.Name
Write-Host $Name "done"