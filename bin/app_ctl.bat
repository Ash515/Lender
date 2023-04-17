    @echo off
     
    setlocal enabledelayedexpansion
     
    rem $Id$
     
    call .\setcommonenv.bat
     
    rem -----------------------------------------------------------------------------
    rem These settings can be modified to fit the needs of your application
    rem Optimized for use with version @wrapper.version@ of the Wrapper.
     
    rem The base name for the Wrapper binary.
    set _WRAPPER_BASE=wrapper
     
    rem The name and location of the Wrapper configuration file.   This will be used
    rem  if the user does not specify a configuration file as the first parameter to
    rem  this script.  It will not be possible to specify a configuration file on the
    rem  command line if _PASS_THROUGH is set.
    if NOT EXIST "%WRAPPER_CONF%" (
    set "WRAPPER_CONF=%SERVER_HOME%/conf/wrapper.conf")
     
    rem _FIXED_COMMAND tells the script to use a hard coded command rather than
    rem  expecting the first parameter of the command line to be the command.
    rem  By default the command will will be expected to be the first parameter.
    rem set _FIXED_COMMAND=console
     
    rem _PASS_THROUGH tells the script to pass all parameters through to the JVM as
    rem  is.
    rem set _PASS_THROUGH=true
     
    set _WRAPPER_CMD=%_WRAPPER_BASE% -c "%WRAPPER_CONF%"
     
    rem Do not modify anything beyond this point
    rem -----------------------------------------------------------------------------
     
    rem BackupDB
    IF "%1" == "backupDB" (
    set WRAPPER_PARAM=wrapper.app.parameter.1000=backupDB wrapper.app.parameter.1001=%2 wrapper.app.parameter.1002=%3 wrapper.app.parameter.1003=%4 wrapper.app.parameter.1004=%5 wrapper.app.parameter.1005=%6 wrapper.app.parameter.1006=%7 wrapper.app.parameter.1007=%8 wrapper.app.parameter.1008=%9
    goto EXECUTE
    )
     
    rem ReinitializeDB
    IF "%1" == "reinitDB" (
    set FORCEFUL_REINIT="false"
    IF "%2" == "-f" set FORCEFUL_REINIT="true"
    set WRAPPER_PARAM=wrapper.app.parameter.1000=reinitDB wrapper.app.parameter.1001=!FORCEFUL_REINIT!
    goto EXECUTE )
     
    Rem restoreDB
    IF "%1" == "restoreDB" (
    if "%2" == "" goto RESTORE_USAGE
	if NOT [%3] == [] (
		if NOT [%3] == [-p] goto RESTORE_USAGE
	)
    set WRAPPER_PARAM=wrapper.app.parameter.1000=restoreDB wrapper.app.parameter.1001=%2 wrapper.app.parameter.1002=%3 wrapper.app.parameter.1003=%4
    goto EXECUTE
     
    :RESTORE_USAGE
    echo Usage app_ctl restoreDB zipfilename -p password
    goto END )
     
    Rem startDB
    IF "%1" == "startDB" (
    if not x"%DB_HOME:pgsql=%" == x"%DB_HOME%" (
    set WRAPPER_PARAM=wrapper.app.parameter.1000=startDB
    goto EXECUTE ) 
    if not x"%DB_HOME:mysql=%" == x"%DB_HOME%" (
    set DB_PORT=%2
    if exist ./startDB.bat  (
        call ./startDB.bat %2
    ) else (
        @start "MySQL" /B "%DB_HOME%\bin\mysqld-nt" --no-defaults --standalone --basedir="%DB_HOME%" --port=!DB_PORT! --datadir="%DB_HOME%\data" --default-character-set=utf8
    )
    goto END ) 
    )
     
    Rem stopDB
    IF "%1" == "stopDB" (
    if not x"%DB_HOME:pgsql=%" == x"%DB_HOME%" (
    rem pgsql stopDB
    set WRAPPER_PARAM=wrapper.app.parameter.1000=stopDB
    goto EXECUTE ) 
    if not x"%DB_HOME:mysql=%" == x"%DB_HOME%" (
    rem mysql stopDB
    set PORT=%2
    set USER_NAME=%3
    set PASSWORD=%4
    set commandArgs=--port !PORT! -u !USER_NAME!
    if NOT "x!PASSWORD!"=="x" set commandArgs=!commandArgs! --password=!PASSWORD!
    @start "mysql" /B "%DB_HOME%\bin\mysqladmin" !commandArgs! shutdown
    goto END ) 
    )
     
    IF "%1" == "standalone" (
    set WRAPPER_PARAM=wrapper.app.parameter.1000=runStandalone 
    goto EXECUTE )
     
    :RESTART
    rem starting MickeyLite server in safe mode
    set SAFE_START="false"
    set START_SERVER="false"
    rem starting MickeyLite server in normal mode
    IF "%1" == "run" (
    set START_SERVER="true"
    goto START )
     
    IF "%2" == "-s" (
    set SAFE_START="true"
    goto START )
     
    :START
    IF %START_SERVER% == "true" (
    echo ===============================================================================
    echo .
    echo .
    echo   SERVER_HOME: "%SERVER_HOME%"
    echo .
    echo   JAVA: "%JAVA%"
    echo .
    echo ===============================================================================
    echo .
    set WRAPPER_PARAM=wrapper.app.parameter.1000=!SAFE_START!
    goto EXECUTE
    )
     
    IF "%1" == "shutdown" (
    set WRAPPER_PARAM=wrapper.app.parameter.1000=shutdown wrapper.app.parameter.1001=localhost wrapper.app.parameter.1002=5 
    goto EXECUTE )
     
    IF "%1" == "serverstatus" (
    set WRAPPER_PARAM=wrapper.app.parameter.1000=serverStatus
    goto EXECUTE )
     
    IF "%1" == "migrateDB" (
    set WRAPPER_PARAM=wrapper.app.parameter.1000=DBMigration wrapper.app.parameter.1001=%2 wrapper.app.parameter.1002=%3
    goto EXECUTE )
     
    IF "%1" == "compareSchema" (
    set WRAPPER_PARAM=wrapper.app.parameter.1000=SchemaAnalyzer wrapper.app.parameter.1001=%2 wrapper.app.parameter.1002=%3
    goto EXECUTE )
     
    IF "%1" == "infodump" (
    set WRAPPER_PARAM=wrapper.app.parameter.1000=infodump wrapper.app.parameter.1001=%2 wrapper.app.parameter.1002=%3 wrapper.app.parameter.1003=%4 
    goto EXECUTE )
     
    IF "%1" == "--help" (
    GOTO EXECUTE )
     
    :EXECUTE
    IF DEFINED WRAPPER_PARAM ( %_WRAPPER_CMD% !WRAPPER_PARAM! ) else ( IF NOT DEFINED WRAPPER_PARAM "%JAVA%" -cp "%SERVER_HOME%\bin\run.jar" com.adventnet.mfw.AppCtlUsage "helpUsage" )
     
    :END