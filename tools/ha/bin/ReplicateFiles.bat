@echo off

setlocal enabledelayedexpansion
set SERVER_HOME=%~dp0..
set LOG_FIle=%SERVER_HOME%\logs\mirror.txt

SET DELETECREDENTIALS="FALSE"
SET LEVEL=0

IF [%5]==[] GOTO USAGE
set REMOTE_MACHINE=%1
set REMOTE_MACHINE=%REMOTE_MACHINE:"=%
SHIFT

IF /I "%1" == "netuse" (
GOTO net_use
)

:main
SHIFT

IF [%4]==[] GOTO USAGE
SET REMOTE=%1
SHIFT
IF /I %REMOTE% == "DEFAULT" (SET REMOTE_LOCATION="%SERVER_HOME:~3%") else (set REMOTE_LOCATION=%REMOTE%)
set REMOTE_LOCATION=%REMOTE_LOCATION:"=%

IF /I "%1" == "MIRROR" (
	SET OPT=/MIR
) ELSE (
	IF /I "%1" == "REPLICATE" (
		SET OPT=
	) ELSE (
		SET OPT=/E
	)
)	
SHIFT

set LOG_FILE=%1
set LOG_FILE=%LOG_FILE:"=%
SHIFT

set dir=%1
set dir=%dir:"=%

SHIFT

GOTO set_opt_new
	
:runcommand
  echo Processing Directory/File : %SERVER_HOME%\%dir%
  robocopy "\\%REMOTE_MACHINE%\%REMOTE_LOCATION%\%dir%" "%SERVER_HOME%\%dir%" /z %OPT% /B /R:0 /W:0 /np /log:"%LOG_FILE%" /ndl /nfl /tee /MT:32 %OPTS%
    if %ERRORLEVEL% EQU 16 echo Status: [ ***FATAL ERROR*** ]
    if %ERRORLEVEL% EQU 15 echo Status: [ OKCOPY + FAIL + MISMATCHES + XTRA ]
    if %ERRORLEVEL% EQU 14 echo Status: [ FAIL + MISMATCHES + XTRA ]
    if %ERRORLEVEL% EQU 13 echo Status: [ OKCOPY + FAIL + MISMATCHES ]
    if %ERRORLEVEL% EQU 12 echo Status: [ FAIL + MISMATCHES ]
    if %ERRORLEVEL% EQU 11 echo Status: [ OKCOPY + FAIL + XTRA ]
    if %ERRORLEVEL% EQU 10 echo Status: [ FAIL + XTRA ]
    if %ERRORLEVEL% EQU 9 echo Status: [ OKCOPY + FAIL ]
    if %ERRORLEVEL% EQU 8 echo Status: [ FAIL ]
    if %ERRORLEVEL% EQU 7 echo Status: [ OKCOPY + MISMATCHES + XTRA ]
    if %ERRORLEVEL% EQU 6 echo Status: [ MISMATCHES + XTRA ]
    if %ERRORLEVEL% EQU 5 echo Status: [ OKCOPY + MISMATCHES ] 
    if %ERRORLEVEL% EQU 4 echo Status: [ MISMATCHES ]
    if %ERRORLEVEL% EQU 3 echo Status: [ OKCOPY + XTRA ]
    if %ERRORLEVEL% EQU 2 echo Status: [ XTRA ]
    if %ERRORLEVEL% EQU 1 echo Status: [ OKCOPY ]
    if %ERRORLEVEL% EQU 0 echo Status: [ No Change ]
    set LEVEL=%ERRORLEVEL%
GOTO END

:USAGE
echo USAGE: mirror.bat [Remote_ip/name] [shareenabled/netuse {sharename,username,password}] [Remote_Installation_Folder/DEFAULT] [MIRROR/COPY] [LOG FILE] [Folder] [Opts]
GOTO END

:net_use
set DELETECREDENTIALS="TRUE"
SHIFT
set SHARENAME=%1
set SHARENAME=%SHARENAME:"=%
SHIFT
set USERNAME=%1
SHIFT
set PASSWORD=%1
echo Logging in using net use command
net use "\\%REMOTE_MACHINE%\%SHARENAME%" /user:"%USERNAME%" %PASSWORD%
GOTO main

:set_opt_new
IF [%1]==[] GOTO runcommand
set OPTS=%OPTS% %1
SHIFT
GOTO set_opt_new


:END
IF /I %DELETECREDENTIALS% == "TRUE" (
echo Deleting log in
net use "\\%REMOTE_MACHINE%\%SHARENAME%" /d
)

EXIT /B %LEVEL%