@echo off
set /p server="Enter server name: "
set /p database="Enter database name: "

sqlcmd -i %cd%\TEST.sql -S %server% -U pdm -P pdm -d %database% -W -s "," -o %cd%\%server%-%database%-DMDetails.csv

::sqlcmd 
::INPUT FILE 		-i Picks up the current directory for the sql script
::SERVER NAME		-S User inputs server name
::DATABASE 		-d User inputs database name
::DMUSERNAME 		-U pdm 
::DMPASSWORD 		-P pdm 
::CUT WHITESPACES 	-W Cuts out the whitespaces in the output
::SEPERATOR 		-s Separator for the output data
::OUTPUT FILE 		-o Saves in current directory and uses other variables as useful name