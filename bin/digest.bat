@echo off
REM # Creates digest for given file in <file>.digest
REM # Author Srivathson KK.
REM ### ====================================================================== ###
REM ##                                                                          ##
REM ## digest.sh <FILES>
REM ##                                                                          ##
REM ### ====================================================================== ###

call .\setCommonEnv.bat

IF "%~1"=="" GOTO SHOW_SYNTAX

set CLASS_PATH="%SERVER_HOME%\lib\framework-tools.jar;%SERVER_HOME%\lib\conf.jar"

"%JAVA%" -cp %CLASS_PATH% com.zoho.framework.utils.FileUtils digest %*
GOTO END_DIGEST

:SHOW_SYNTAX
echo Syntax: %0 p1 [p2...]

:END_DIGEST
