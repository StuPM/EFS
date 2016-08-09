# ------ 
# This scripts finds all installations of DM, JFinder and BPM
# It then creates a Favourite in the Internet Explorer favourite bar
# ------


#Used for creating the URLs
$firstURL = 'http://localhost:'


function checkForJFinder {

    Write-Host Checking for JFinder service

    #Get the JFinder service full path
    $JFinderService = Get-WmiObject win32_service -ComputerName localhost | ?{$_.name -like '*JFinder*'} | select DisplayName, PathName

    #Check if null
    if($JFinderService){
        #Take the unneeded part off then add TomcatService
        $installPath = Split-Path $JFinderService.PathName -Parent 
        $pathToCheck = $installPath + "\conf\TomcatService.xml"
              
        #Check if the TomcatService file exists
        if(Test-Path $pathToCheck){
            #If it does, get the XML and find the port
            [xml]$tomcatXML = Get-Content $pathToCheck
            $jfPort = $tomcatXML.'tomcat-service-config'.'www-port'

        } else {
            #For if the TomcatService file cannot be found
            Write-Host "Cannot find JFinder settings file at" $pathToCheck
        }

        #Find stdout for JFinder version
        $stdPath = $installPath + "\stdout.txt"
        foreach ($line in (Get-Content $stdPath)) {
            if($line.Contains("starting...")) {
                $versionRegex = "v\d{2,}"
                $temp = $line -match $versionRegex
				$version = $Matches[0]
				break
            }
        }
        
        createShortcut -shortcutURL $firstURL$jfPort'/jfinder' -name "JFinder $version"

    } else {
        Write-Host JFinder service not found
    }
}

function checkForDM {
    
    #Get a list of DMs installed
    $DMServiceList = Get-WmiObject win32_service -ComputerName localhost | ?{$_.name -like 'autoform *dm*' -and $_.name -notlike '*bpm*'} | select DisplayName, PathName, StartName
    Write-Host Checking for DM installs',' @($DMServiceList).Count found

    #Loop through and get the port
    $runCounter = 0
    while($runCounter -lt @($DMServiceList).Count){
        
    $selected = $DMServiceList[$runCounter]

    $versionRegex = "[0-9].[0-9].[0-9]{1,2}"
    $dmVersion = $selected -match $versionRegex
    $dmVersion = 'DM ' + $Matches[0]
          
    if ($selected.PathName.Contains('"')) {
			$selectedPath = $selected.PathName.Split('"')[1]
            $selectedPath = $selectedPath.Replace("bin\wrapper.exe", "standalone\configuration\standalone.xml")

            if($selectedPath) {
                [xml]$standaloneConfig = Get-Content $selectedPath
                $socketList = $standaloneConfig.server.'socket-binding-group'.'socket-binding'
                    foreach($socket in $socketList) {
                        if($socket.name -eq 'http') {
                            $DMPort = $socket.port
                            break
                        }
                    }                  
            }
	} #change to check the displayname for the version isntead
    
    createShortcut -shortcutURL $firstURL$DMPort'/dm/dm.do' -name $dmVersion 

        $runCounter++
    }

    if(@($DMServiceList).Count -eq 0) {
        Write-Host DM is not installed
    }

}

function checkForBPM {

    #Check for BPMs installed
    $BPMServiceList = Get-WmiObject win32_service -ComputerName localhost | ?{$_.name -like '*bpm*'} | select DisplayName, PathName
    Write-Host Checking for BPM installs',' @($BPMServiceList).Count found

    $runCounter = 0
    while($runCounter -lt @($BPMServiceList).Count) {

        $selectedService = $BPMServiceList[$runCounter]
  
        $BPMVersionRegex = "\d.\d.\d"
        $selectedService -match $BPMVersionRegex | Out-Null
        $BPMVersion = 'BPM ' + $Matches[0]
        $port = 0 

        if($Matches[0].StartsWith(3)) {
                    
            $BPMInstallRegex = "[A-Z]:[^\`"]+\\(w|W)ildfly-service\.exe"
            $tempInstall = $selectedService.PathName -match $BPMInstallRegex
            $installPath = $Matches[0]
            $installPath = Split-Path $installPath -Parent
            
		    $installPath = $installPath -replace 'bin\\service\\amd64',''
            $installPath = $installPath + 'app.properties'

            $appPropFile = Get-Content $installPath
            foreach($line in $appPropFile) {
                if($line -match 'jboss.http.port') {
                    $port = $line.Substring(16)
                    break                    
                 }
            }

            createShortcut -shortcutURL $firstURL$port'/bpm' -name $BPMVersion

        }
        elseif($Matches[0].StartsWith(2)){

            $BPMInstallRegex = "[A-Z]:[^\`"]+\\(w|W)rapper.exe"
            $tempInstall = $selectedService.PathName -match $BPMInstallRegex
            $installPath = $Matches[0]
            $installPath = $installPath -replace 'bin\\\wrapper.exe',''
            $installPath = $installPath + 'config\tomcat-server.xml'
            
            
            if($installPath) {
                [xml]$tomcatFile = Get-Content $installPath
                $port = $tomcatFile.Server.Service.Connector.GetAttribute("port")
                $port = $port[0]
            }
                    
                    
            createShortcut -shortcutURL $firstURL$port'/bpm' -name $BPMVersion

             
            }
            
    $runCounter = $runCounter +1
                
    }

    if(@($BPMServiceList).Count -eq 0) {
        Write-Host BPM is not installed
    }

}


function createShortcut {
    
    Param ([String] $shortcutURL, [String] $name)

    Write-Host $name URL added for $shortcutURL

    #Shell created to add new links
    $IEFav = [Environment]::GetFolderPath('Favorites', 'None') 
    $Shell = New-Object -ComObject WScript.Shell
    $IEFav = Join-Path -Path $IEFav -ChildPath 'Links'

    
    $FullPath = Join-Path -Path $IEFav -ChildPath "$($Name).url"
    
    $shortcut = $Shell.CreateShortcut($FullPath)
    $shortcut.TargetPath = $shortcutURL
    $shortcut.Save()
   

}


checkForJFinder
checkForDM
checkForBPM
