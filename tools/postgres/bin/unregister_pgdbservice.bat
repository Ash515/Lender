@ echo off

call .\setcommonenv.bat

setlocal
set ERR_CODE = 0
IF [%1] == [] GOTO PrintUsage
set DB_SERVICE_NAME=%1

echo "%DB_HOME%"
echo Unregistring DB NT service %DB_SERVICE_NAME%...

"%DB_HOME%\bin\pg_ctl.exe" unregister -N %DB_SERVICE_NAME%
rem sc delete %DB_SERVICE_NAME%
set ERR_CODE=%ERRORLEVEL%

IF %ERRORLEVEL% == 0 GOTO Success

IF %ERRORLEVEL% NEQ 0 GOTO PrintErrorMsg

:Success
	echo DB service unregistered successfully.
	goto End
	
:PrintUsage
	set ERR_CODE=1
	echo DB Service Name argument is missing.
	echo Usage :: unregister_pgdbservice.bat DB_SERVICE_NAME
	echo Eg :: unregister_pgdbservice.bat postgresql
	goto End	

:PrintErrorMsg
	set ERR_CODE=1
	echo "Unable to unregister DB service"

:End

endlocal & exit /b %ERR_CODE%
rem $Id$
