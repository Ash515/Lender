@ echo off

rem set DB_HOME=%cd%\..\pgsql
call "%~dp0\setcommonenv.bat"

setlocal
set ERR_CODE = 0
IF [%1] == [] GOTO PrintUsage
set DB_SERVICE_NAME=%1
echo "%DB_HOME%"
echo Registring NT service %DB_SERVICE_NAME%...

"%DB_HOME%\bin\pg_ctl.exe" register -N %DB_SERVICE_NAME% -D "%DB_HOME%\data" -S demand
rem sc create %DB_SERVICE_NAME% binPath= "%DB_HOME%\bin\pg_ctl.exe" runservice -N \"%DB_SERVICE_NAME%\" -D \"%DB_HOME%\data\"" start= demand
set ERR_CODE=%ERRORLEVEL%

IF %ERRORLEVEL% == 0 GOTO Success

IF %ERRORLEVEL% NEQ 0 GOTO PrintErrorMsg

:Success
	echo DB service registered successfully.
	goto End

:PrintUsage
	set ERR_CODE=1
	echo DB Service Name argument is missing.
	echo Usage :: register_pgdbservice.bat DB_SERVICE_NAME
	echo Eg :: register_pgdbservice.bat postgresql
	goto End

:PrintErrorMsg
	set ERR_CODE=1
	echo "Unable to register DB service"

:End

endlocal & exit /b %ERR_CODE%
rem $Id$




