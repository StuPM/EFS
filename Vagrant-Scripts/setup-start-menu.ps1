# -----
# By copying the itemdata-ms file to the designated folder
# Sets up the start menu with useful pinned programs
# Tested only on Windows Server 2012
# -----

Copy-Item "C:\vagrant\Scripts\appsFolder.itemdata-ms" -Destination "C:\Users\vagrant\AppData\Local\Microsoft\Windows"
$Name = $MyInvocation.MyCommand.Name
Write-Host $Name "done"