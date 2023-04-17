@ echo off
rem ### ====================================================================== ###
rem ##                                                                          ##
rem ## change_datadir_perm.bat  <path-to-data-directory>
rem ##                                                                          ##
rem ### ====================================================================== ###
rem Script file to change PostgreSQL datadirectory permission in Windows.

call "%~dp0\setCommonEnv.bat"

setlocal
set DB_USERNAME=postgres
set CACL_CMD="%SystemRoot%\system32\icacls.exe"
set DATA_DIR="%DB_HOME%\data"
set SCRIPT_ARG=%1

IF (%SCRIPT_ARG%) == () (GOTO BEGIN) ELSE (GOTO SET_DATA_DIR_PATH)

:SET_DATA_DIR_PATH
	set DATA_DIR=%SCRIPT_ARG%
	set DB_HOME="%DATA_DIR%\..\"
	
:BEGIN
	set CURRENT_LOCATION="%~dp0"
	cd %DB_HOME%
	set DB_HOME=%cd%
	cd %DATA_DIR%
	set DATA_DIR_PATH=%cd%
	set DATA_DIR="%DATA_DIR_PATH%"
	set EXTCONF_DIR="%DB_HOME%\ext_conf"
	cd %CURRENT_LOCATION%
	echo DB Home :: %DB_HOME%
	echo DATA_DIR :: %DATA_DIR%
	echo EXTCONF_DIR :: %EXTCONF_DIR%
	echo.
	
:RESET_PERMISSION
	echo * Resetting Permissions
	%CACL_CMD% %DATA_DIR% /T /C /grant "%userdomain%\%username%":(OI)(CI)F /Q		/T /C /grant "NT AUTHORITY\NetworkService":(OI)(CI)F /Q
	%CACL_CMD% %DATA_DIR% 	/grant *S-1-3-0:(OI)(CI)F /Q	/grant *S-1-5-18:(OI)(CI)F /Q	 /grant *S-1-5-32-544:(OI)(CI)F /Q 	 /inheritance:r /Q
	%CACL_CMD% %DATA_DIR% /findsid *s-1-5-11 | find /i %DATA_DIR% > nul
	IF %ERRORLEVEL% EQU 0 %CACL_CMD% %DATA_DIR% /T /remove *S-1-5-11 /Q
	
	IF EXIST %EXTCONF_DIR% (
		GOTO RESET_EXT_PERMISSION
	) ELSE (
		GOTO PROCEED
	)
	
:RESET_EXT_PERMISSION
	echo * Resetting Permissions for ext_conf directory
	%CACL_CMD% %EXTCONF_DIR% /T /C /grant "%userdomain%\%username%":(OI)(CI)F /Q		/T /C /grant "NT AUTHORITY\NetworkService":(OI)(CI)F /Q
	%CACL_CMD% %EXTCONF_DIR%  /grant *S-1-3-0:(OI)(CI)F /Q	/grant *S-1-5-18:(OI)(CI)F /Q	 /grant *S-1-5-32-544:(OI)(CI)F /Q	 /inheritance:r /Q
	%CACL_CMD% %EXTCONF_DIR% /findsid *s-1-5-11 | find /i %EXTCONF_DIR% > nul
	IF %ERRORLEVEL% EQU 0 %CACL_CMD% %EXTCONF_DIR% /T /remove *S-1-5-11 /Q

:PROCEED
	IF %ERRORLEVEL% == 0 GOTO SUCCESS
	IF %ERRORLEVEL% NEQ 0 GOTO PrintErrorMsg

:SUCCESS
	echo Permissions changed successfully.
	goto End

:PrintErrorMsg
        echo Problem while setting permissions.

:End
        if EXIST "%TMP_DIR%" (rmdir /S /Q "%TMP_DIR%")


endlocal
rem $Id$
