@echo off

setlocal enabledelayedexpansion

IF "%1" == "" GOTO USAGE
IF "%1"=="add" (
	IF "%2" == "" GOTO USAGE
	IF NOT "%3" == "" SET IFNAME=-if %3
	IF NOT "%4" == "" SET MASK=-mask %4	
	ipadd %2 !IFNAME! !MASK!
	GOTO END
)

IF "%1"=="delete" (
	IF "%2" == "" GOTO USAGE
	ipdel %2	
	GOTO END
) 

IF "%1"=="iflist" (
	iflist
	GOTO END
)

IF "%1"=="ifcheck" (
	ifcheck %2
	GOTO END
)

:USAGE
echo USAGE: ipHandler.bat [ options ]
echo options :: 
echo add IPAddr Interface_Name NetMask    -- To bind the given IP to machine
echo delete IPAddr Interface_Name NetMask -- To unbind the given IP from machine
echo iflist				     -- To print the list of available Network Interfaces
echo ifcheck Interface_Name		     -- To check if the provided interface is up
echo This script should be run with administrator privileges.

:END

endlocal & exit /b %ERRORLEVEL%