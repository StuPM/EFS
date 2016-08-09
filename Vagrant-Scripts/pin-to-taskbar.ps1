# -----
# Pins useful programs to the taskbar
# ----

$shell = new-object -com "Shell.Application"

#1 - Pin Internet Explorer to taskbar
$folder = $shell.Namespace('C:\Program Files\Internet Explorer')
$item = $folder.Parsename('iexplore.exe')
$verb = $item.Verbs() | ? {$_.Name -eq 'Pin to Tas&kbar'}
if ($verb) {$verb.DoIt()}

#2 - Pin LaserNet Developer to taskbar
$folder = $shell.Namespace('C:\Program Files\EFS Technology\AUTOFORM LN\LaserNet 7')
$item = $folder.Parsename('LnDeveloper.exe')
$verb = $item.Verbs() | ? {$_.Name -eq 'Pin to Tas&kbar'}
if ($verb) {$verb.DoIt()}

#2 - Pin LaserNet Developer to taskbar
$folder = $shell.Namespace('C:\Program Files\EFS Technology\AUTOFORM LN\LaserNet 7')
$item = $folder.Parsename('LnMonitor.exe')
$verb = $item.Verbs() | ? {$_.Name -eq 'Pin to Tas&kbar'}
if ($verb) {$verb.DoIt()}

#3 - Pin Services to taskbar
$folder = $shell.Namespace('C:\Windows\System32\en-US')
$item = $folder.Parsename('services.msc')
$verb = $item.Verbs() | ? {$_.Name -eq 'Pin to Tas&kbar'}
if ($verb) {$verb.DoIt()}

$Name = $MyInvocation.MyCommand.Name
Write-Host $Name "done"