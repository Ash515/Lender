@ echo off

call "%~dp0\setCommonEnv.bat"

setlocal
set DB_USERNAME=postgres
set CACL_CMD="%SystemRoot%\system32\icacls.exe"
set FIND_CMD="%SystemRoot%\system32\find.exe"
set DB_PASSWORD=%1
set AUTH_MODE=md5
set IS_INITDB_REQUIRED=false
set ERR_CODE = 0

set CURRENT_LOCATION="%~dp0"
cd %DB_HOME%
set DB_HOME=%cd%
cd %CURRENT_LOCATION%

echo DB Home :: %DB_HOME%

set DATA_DIR="%DB_HOME%\data"
set EXTCONF_DIR="%DB_HOME%\ext_conf"

for /f "delims=" %%i in ('^""%DB_HOME%\bin\postgres" -V^"') do set version=%%i
echo PostgreSQL Version :: %version%
echo.

mkdir  "%DB_HOME%\tmp"

:BEGIN
	echo ** Setting up PostgreSQL Installation Directory
	%CACL_CMD% "%DB_HOME%" /grant "%userdomain%\%username%":(NP)(RX) /Q
	%CACL_CMD% "%DB_HOME%\bin" /T /C /grant:r "%userdomain%\%username%":(OI)(CI)(RX) /Q
	%CACL_CMD% "%DB_HOME%\lib" /T /C /grant:r "%userdomain%\%username%":(OI)(CI)(RX) /Q
	%CACL_CMD% "%DB_HOME%\share" /T /C /grant:r "%userdomain%\%username%":(OI)(CI)(RX) /Q
	IF EXIST "%DB_HOME%\LICENSE" %CACL_CMD% "%DB_HOME%\LICENSE" /T /C /grant:r "%userdomain%\%username%":(OI)(CI)(RX) /Q 
	echo.
	if EXIST %DATA_DIR% (GOTO CHANGE_PERMISSION) ELSE (GOTO START)

:START
	IF "%1" == "" (
		echo "Usage : initPgsql.bat <password>"
    	echo "Password not supplied"
    	set ERR_CODE=1
    	GOTO PrintErrorMsg
    ) ELSE (
		GOTO CREATE_DATADIR
	)

:CREATE_DATADIR
	set IS_INITDB_REQUIRED=true
	echo ** Setting up Data Directory
	echo * Creating data directory
	mkdir %DATA_DIR%
	echo * Associating permissions to Data Directory
	%CACL_CMD% %DATA_DIR% /T /C /grant "%userdomain%\%username%":(OI)(CI)F /Q		/T /C /grant "NT AUTHORITY\NetworkService":(OI)(CI)F /Q
	
	%CACL_CMD% %DATA_DIR%  /grant *S-1-3-0:(OI)(CI)F /Q	/grant *S-1-5-18:(OI)(CI)F /Q	 /grant *S-1-5-32-544:(OI)(CI)F /Q	  /inheritance:r /Q
	echo.

:SETUP_CONF_DIR
	echo ** Setting up Configuration Directory
	if NOT EXIST %EXTCONF_DIR% (
		GOTO CREATE_CONF_DIR
	) ELSE (
		echo Configuration Directory already exists. Skipping directory creation.
		GOTO COPY_CONF_FILE
	)

:CREATE_CONF_DIR
	mkdir  %EXTCONF_DIR%
	echo Created Configuration Directory

:COPY_CONF_FILE
	if NOT EXIST %EXTCONF_DIR%\00framework_ext.conf (
		echo Copying Framework Configuration
		copy "%DB_HOME%\share\00framework_ext.conf" %EXTCONF_DIR% > nul
	) ELSE (
		echo Framework Configuration already exists
	)
	echo.
	
:SET_EXTCONF_PERM
	echo Setting permissions for EXT_CONF directory
	
	%CACL_CMD% %EXTCONF_DIR% /T /C /grant "%userdomain%\%username%":(OI)(CI)F /Q 		/T /C /grant "NT AUTHORITY\NetworkService":(OI)(CI)F /Q
	
	%CACL_CMD% %EXTCONF_DIR%  /grant *S-1-3-0:(OI)(CI)F /Q	/grant *S-1-5-18:(OI)(CI)F /Q	 /grant *S-1-5-32-544:(OI)(CI)F /Q	  /inheritance:r /Q

:INITDB
	echo ** Initializing Data Directory
	
:VALIDATE_AUTHMODE
	IF "%2"=="scram-sha-256" (
		SET AUTH_MODE=scram-sha-256
		GOTO SET_AUTHMODE
	)
	IF "%2"=="md5" GOTO SET_AUTHMODE
	IF "%2"=="" GOTO SET_AUTHMODE
	echo "Usage : initPgsql.bat <password> <AuthMode(optional)>(md5/scram-sha-256)"
	echo Invalid AuthMode "%2" supplied. Only md5 or scram-sha-256 is allowed. md5 will be considered if no parameter is supplied.
	set ERR_CODE=1
	GOTO PrintErrorMsg

:SET_AUTHMODE
	echo %DB_PASSWORD%>"%DB_HOME%\tmp\pwd.txt"
	echo * Authentication mode set to %AUTH_MODE%
	set DB_AUTHMODE=--pwfile "%DB_HOME%\tmp\pwd.txt" -A %AUTH_MODE%

:RUN_INITDB
	echo * Running initdb
	"%DB_HOME%\bin\initdb.exe" -U %DB_USERNAME% -D %DATA_DIR% --no-locale -E UTF8 %DB_AUTHMODE%
	if EXIST "%DB_HOME%\tmp" (rmdir /S /Q "%DB_HOME%\tmp")
	echo.
	set ERR_CODE=%ERRORLEVEL%
	IF %ERR_CODE% NEQ 0 (
		rmdir /S /Q %DATA_DIR%
		GOTO PrintErrorMsg
	) ELSE (
		GOTO CHANGE_PERMISSION
	)

:CHANGE_PERMISSION
	echo ** Granting privileges for Data Directory
	IF NOT %IS_INITDB_REQUIRED% == true GOTO RESET_PERMISSION
	GOTO SET_LOCAL_TIMEZONE

:RESET_PERMISSION
	echo * Resetting Permissions
	%CACL_CMD% %DATA_DIR% /T /C /grant "%userdomain%\%username%":(OI)(CI)F /Q		/T /C /grant "NT AUTHORITY\NetworkService":(OI)(CI)F /Q
	%CACL_CMD% %DATA_DIR% 	/grant *S-1-3-0:(OI)(CI)F /Q	/grant *S-1-5-18:(OI)(CI)F /Q	 /grant *S-1-5-32-544:(OI)(CI)F /Q 	 /inheritance:r /Q
	%CACL_CMD% %DATA_DIR% /findsid *s-1-5-11 | %FIND_CMD% /i %DATA_DIR% > nul
	IF %ERRORLEVEL% EQU 0 %CACL_CMD% %DATA_DIR% /T /remove *S-1-5-11 /Q

	%CACL_CMD% %EXTCONF_DIR% /T /C /grant "%userdomain%\%username%":(OI)(CI)F /Q		/T /C /grant "NT AUTHORITY\NetworkService":(OI)(CI)F /Q
	%CACL_CMD% %EXTCONF_DIR%  /grant *S-1-3-0:(OI)(CI)F /Q	/grant *S-1-5-18:(OI)(CI)F /Q	 /grant *S-1-5-32-544:(OI)(CI)F /Q	 /inheritance:r /Q
	%CACL_CMD% %EXTCONF_DIR% /findsid *s-1-5-11 | %FIND_CMD% /i %EXTCONF_DIR% > nul
	IF %ERRORLEVEL% EQU 0 %CACL_CMD% %EXTCONF_DIR% /T /remove *S-1-5-11 /Q

:SET_LOCAL_TIMEZONE
	echo ** Setting local time zone
	"%SERVER_HOME%\tools\postgres\bin\gettimezone.exe" "%DB_HOME%/share/" %EXTCONF_DIR%\00framework_ext.conf
	echo.
	set ERR_CODE=%ERRORLEVEL%
	IF %ERR_CODE% EQU 0 (
    	GOTO COPY_ARCHIVE_SCRIPT
	) ELSE (
		GOTO PrintErrorMsg
	)

:COPY_ARCHIVE_SCRIPT
	echo ** Copying Archive Script
	if EXIST "%SERVER_HOME%\tools\postgres\bin\archive.bat" ((copy "%SERVER_HOME%\tools\postgres\bin\archive.bat" %DATA_DIR% >nul) && (echo Archive Script copied successfully)) ELSE (echo Archive Script not found. Skipping copy task)
	echo.

:Success
	echo PostgreSQL DB initialized successfully.
	goto End

:PrintErrorMsg
	echo Problem while initializing PostgreSQL DB. (Error : %ERR_CODE%)

:End
	if EXIST "%DB_HOME%\tmp" (rmdir /S /Q "%DB_HOME%\tmp")

endlocal & exit /b %ERR_CODE%
rem $Id$
