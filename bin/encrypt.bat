@echo off
REM # Automate the encryption for the given plaintext.
REM # Author Divya J.
REM ### ====================================================================== ###
REM ##                                                                          ##
REM ## encrypt.bat  <PLAIN_TEXT> 
REM ##                                                                          ##
REM ### ====================================================================== ###

call .\setCommonEnv.bat

set CLASS_PATH="%SERVER_HOME%\lib\framework-tools.jar;%SERVER_HOME%\lib\conf.jar"

IF "%1"=="" GOTO SHOW_SYNTAX

"%JAVA%"  -Dserver.home="%SERVER_HOME%" -cp %CLASS_PATH% com.zoho.framework.utils.crypto.CryptoUtil %*
GOTO END_ENCRYPT

:SHOW_SYNTAX 
"%JAVA%" -Dserver.home="%SERVER_HOME%" -cp %CLASS_PATH% com.zoho.framework.utils.crypto.CryptoUtil "showUsage"

:END_ENCRYPT
